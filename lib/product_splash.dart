import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/db_providers.dart';
import 'product_list_display.dart';

class ProductSplash extends ConsumerStatefulWidget {
  const ProductSplash({super.key});

  @override
  ConsumerState<ProductSplash> createState() => _ProductSplashState();
}

class _ProductSplashState extends ConsumerState<ProductSplash> {

  @override
  void initState() {
    super.initState();
    _syncProducts();
  }

  // TODO:: SYNC PRODUCTS
  Future<void> _syncProducts() async {
    try {
      final syncService = ref.read(productSyncProvider);

      await syncService.syncProducts();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProductList(),
        ),
      );
    } catch (error) {
      debugPrint('Product sync failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}