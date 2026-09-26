import 'dart:io';

void main() async {
  final directory = Directory('lib');
  
  if (!directory.existsSync()) {
    return;
  }
  
  final files = directory.listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart'));
  
  // ignore: unused_local_variable
  int updatedFiles = 0;
  
  for (final file in files) {
    bool hasChanges = false;
    final lines = await file.readAsLines();
    final newLines = <String>[];
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      // Regex to detect widget classes
      final classRegex = RegExp(r'^class\s+([A-Z][a-zA-Z0-9_]*)\s+extends\s+(?:StatelessWidget|StatefulWidget|State\<|ConsumerWidget|StatefulHookConsumerWidget|HookConsumerWidget|ConsumerStatefulWidget)');
      
      var match = classRegex.firstMatch(line.trim());
      if (match != null) {
        final className = match.group(1);
        
        // Check if previous line is a comment or annotation
        bool hasComment = false;
        int checkIndex = i - 1;
        while (checkIndex >= 0) {
          final prevLine = lines[checkIndex].trim();
          if (prevLine.isEmpty) {
            checkIndex--;
            continue;
          }
          if (prevLine.startsWith('///') || prevLine.startsWith('//') || prevLine.startsWith('/*')) {
            hasComment = true;
          } else if (prevLine.startsWith('@')) {
             checkIndex--;
             continue; // go past decorators
          }
          break; // found something that is not empty/decorator
        }
        
        if (!hasComment && !line.trim().startsWith('///') && !line.trim().startsWith('//')) {
          // Add comment
          String humanReadable = className!.replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'), (m) => ' ${m.group(0)}');
          newLines.add('/// A widget representing the $humanReadable.');
          hasChanges = true;
        }
      }
      
      newLines.add(line);
    }
    
    if (hasChanges) {
      // ignore: prefer_interpolation_to_compose_strings
      await file.writeAsString(newLines.join('\n') + '\n');
      updatedFiles++;
    }
  }
  
}
