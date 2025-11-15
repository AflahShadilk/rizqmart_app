import 'package:flutter/material.dart';

void showToast(BuildContext context,String message){
   final overlay=Overlay.of(context);
   // ignore: unnecessary_null_comparison
   if(overlay==null)return;
    final entry=OverlayEntry(builder: (context)=>Positioned(
      top: 80,
      left: MediaQuery.of(context).size.width * 0.2,
      width: MediaQuery.of(context).size.width * 0.6,
      child:Material(
        color: Colors.transparent,
        child: AnimatedOpacity(opacity: 1, duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.8),
             borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
        ),
        
        ),
      ) ));
      overlay.insert(entry);
      Future.delayed(const Duration(milliseconds: 1200)).then((_){entry.remove();});
  }