import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/strings.dart';

final foodProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection(AppStrings.foodsCollection)
      .get();

  return snapshot.docs.map((doc) => doc.data()).toList();
});
// TODO:: SEARCH PROVIDER

class SearchNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  // TODO:: UPDATE SEARCH

  void updateSearch(String query) {
    state = query;
  }

  // TODO:: CLEAR SEARCH

  void clearSearch() {
    state = '';
  }
}

// TODO:: SEARCH PROVIDER

final searchProvider =
NotifierProvider<SearchNotifier, String>(
  SearchNotifier.new,
);