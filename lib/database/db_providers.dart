import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'product_dao.dart';
import '../services/products_syn.dart';

final dbProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final productDaoProvider = Provider<ProductDao>((ref) {
  final database = ref.watch(dbProvider);

  return ProductDao(database);
});
final productsProvider = FutureProvider<List<Product>>((ref) {
  final dao = ref.watch(productDaoProvider);

  return dao.getAllProducts();
});
final productSyncProvider = Provider<ProductSyncService>((ref) {
  final productDao = ref.watch(productDaoProvider);

  return ProductSyncService(productDao);
});