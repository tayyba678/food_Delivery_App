import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'database/db_providers.dart';
import 'utils/colors.dart';
import 'utils/strings.dart';

class ProductList extends ConsumerStatefulWidget {
  const ProductList({super.key});

  @override
  ConsumerState<ProductList> createState() => _ProductListState();
}

class _ProductListState extends ConsumerState<ProductList> {

  // TODO:: MAIN BUILD METHOD
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 60,
            left: 30,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO:: PRODUCT HEADER
              _buildProductHeader(),
              const SizedBox(height: 20),

              // TODO:: PRODUCT CONTENT
              _buildContentArea(productsAsync),
            ],
          ),
        ),
      ),
    );
  }

  // TODO:: PRODUCT HEADER WIDGET
  Widget _buildProductHeader() {
    return const Text(
      AppStrings.products,
      style: TextStyle(
        fontFamily: AppStrings.robotoFont,
        fontSize: 28,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // TODO:: CONTENT AREA WIDGET
  Widget _buildContentArea(
      AsyncValue<List<Product>> productsAsync,
      ) {
    return productsAsync.when(
      loading: () {
        return const SizedBox(
          height: 300,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryOrange,
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Text(
              'Error: $error',
              style: const TextStyle(
                fontFamily: AppStrings.robotoFont,
                color: AppColors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
      data: (products) {
        if (products.isEmpty) {
          return const Center(
            child: Text(
              'No products found',
              style: TextStyle(
                fontFamily: AppStrings.robotoFont,
                fontSize: 16,
              ),
            ),
          );
        }

        return _buildProductGrid(products);
      },
    );
  }

  // TODO:: PRODUCT GRID WIDGET
  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        mainAxisExtent: 250,
      ),
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  // TODO:: PRODUCT CARD WIDGET
  Widget _buildProductCard(Product product) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating
          Row(
            children: [
              const Icon(
                Icons.star,
                color: AppColors.starYellow,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                product.rating.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppStrings.dmSansFont,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Product Image
          Center(
            child: SizedBox(
              height: 90,
              child: Image.network(
                product.thumbnail,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Product Title
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: AppStrings.dmSansFont,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Product Description
          Text(
            product.description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.black,
              fontFamily: AppStrings.dmSansFont,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          // Price
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryOrange,
              fontFamily: AppStrings.dmSansFont,
            ),
          ),
        ],
      ),
    );
  }
}