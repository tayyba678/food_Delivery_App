import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tables/products.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<AppDatabase>
    with _$ProductDaoMixin {
  ProductDao(AppDatabase db) : super(db);

  // TODO:: INSERT PRODUCT
  Future<int> insertProduct(ProductsCompanion product) {
    return into(products).insert(product);
  }

  // TODO:: GET ALL PRODUCTS
  Future<List<Product>> getAllProducts() {
    return select(products).get();
  }

  // TODO:: UPDATE PRODUCT
  Future<bool> updateProduct(Product product) {
    return update(products).replace(product);
  }

  // TODO:: DELETE PRODUCT
  Future<int> deleteProduct(int id) {
    return (delete(products)..where((tbl) => tbl.id.equals(id))).go();
  }
}