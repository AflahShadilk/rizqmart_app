// import 'package:flutter/widgets.dart';

// class SearchHelper<T> {
//    List<T> allItems;
//   final bool Function(T item, String query) matcher;

//   SearchHelper({
//     required this.allItems,
//     required this.matcher,
//   });

//   TextEditingController controller = TextEditingController();

//   bool isSearching = false;
//   List<T> filteredItems = [];

//   void onSearch(String query) {
//     isSearching = query.isNotEmpty;

//     if (query.isEmpty) {
//       filteredItems = [];
//       return;
//     }

//     filteredItems = allItems
//         .where((item) => matcher(item, query.toLowerCase()))
//         .toList();
//   }

//   void clearSearch() {
//     controller.clear();
//     isSearching = false;
//     filteredItems = [];
//   }
// }
