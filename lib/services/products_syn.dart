import '../api/product_api.dart';
import '../database/product_dao.dart';
import '../database/tables/products.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../product_list_display.dart';

class ProductSyncService {
  final ProductDao productDao;

  ProductSyncService(this.productDao);

  // TODO:: SYNC PRODUCTS
  Future<void> syncProducts() async {
    final apiProducts = await ProductApi.getProducts();

    final products = apiProducts.map((product) {
      return ProductsCompanion.insert(
        id: Value(product['id'] as int),
        title: product['title'] as String,
        price: (product['price'] as num).toDouble(),
        description: product['description'] as String,
        category: product['category'] as String,
        thumbnail: product['thumbnail'] as String,
        rating: (product['rating'] as num).toDouble(),
      );
    }).toList();

    await productDao.replaceAllProducts(products);
  }

}