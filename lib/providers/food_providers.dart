import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/strings.dart';

final foodProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection(AppStrings.foodsCollection)
      .get();

  return snapshot.docs.map((doc) => doc.data()).toList();
});