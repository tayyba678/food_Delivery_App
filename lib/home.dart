import 'package:flutter/material.dart';
import 'food_Description.dart';
import 'animated_food_cart.dart';
import 'utils/colors.dart';
import 'utils/strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/food_providers.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // TODO:: SEARCH LOGIC
  void _onSearchChanged() { setState(() {});
  }



  // TODO:: MAIN BUILD METHOD
  @override
  Widget build(BuildContext context) {
    final foodsAsync = ref.watch(foodProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                // Location Header
                _buildLocationHeader(),
                const SizedBox(height: 20),

                // Order Title
                _buildOrderTitle(),
                const SizedBox(height: 20),

                // Search Bar
                _buildSearchField(),
                const SizedBox(height: 20),

                // Categories Header
                _buildCategoriesHeader(),
                const SizedBox(height: 12),

                // Category Tabs
                _buildTabBar(),

                // Content Area (Loading, Error, or Food Tabs)
                _buildContentArea(foodsAsync),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // TODO:: LOCATION HEADER WIDGET
  Widget _buildLocationHeader() {
    return Row(
      children: [
        Image.asset(AppStrings.locationIcon),
        const SizedBox(width: 8),
        const Text(
          AppStrings.locationText,
          style: TextStyle(
            fontSize: 16,
            fontFamily: AppStrings.robotoFont,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Image.asset(AppStrings.downArrowIcon),
      ],
    );
  }

  // TODO:: ORDER TITLE WIDGET
  Widget _buildOrderTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Text(
            AppStrings.orderTitle,
            style: TextStyle(
              fontFamily: AppStrings.robotoFont,
              fontSize: 28,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Image.asset(AppStrings.deliveryIcon),
      ],
    );
  }

  // TODO:: SEARCH FIELD WIDGET
  Widget _buildSearchField() {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppStrings.searchHint,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              hintStyle: const TextStyle(
                fontFamily: AppStrings.robotoFont,
                fontSize: 16,
                color: AppColors.searchHint,
              ),
              prefixIcon: Image.asset(AppStrings.searchIcon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.searchBorder,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Image.asset(AppStrings.searchFrontIcon),
        ),
      ],
    );
  }

  // TODO:: CATEGORIES HEADER WIDGET
  Widget _buildCategoriesHeader() {
    return const Text(
      AppStrings.categories,
      style: TextStyle(
        fontFamily: AppStrings.robotoFont,
        fontSize: 18,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // TODO:: TAB BAR WIDGET
  Widget _buildTabBar() {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.only(right: 5),
      dividerColor: AppColors.transparent,
      overlayColor: WidgetStateProperty.all(AppColors.transparent),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: const EdgeInsets.only(right: 5),
      indicator: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(10),
      ),
      labelColor: AppColors.white,
      unselectedLabelColor: AppColors.black,
      tabs: [
        _buildCategoryTab(AppStrings.burgerIcon, AppStrings.burger, 123),
        _buildCategoryTab(AppStrings.pizzaIcon, AppStrings.pizza, 110, isPizza: true),
        _buildCategoryTab(AppStrings.sandwichIcon, AppStrings.sandwich, 150),
      ],
    );
  }

  // TODO:: INDIVIDUAL CATEGORY TAB WIDGET
  Widget _buildCategoryTab(String icon, String label, double width, {bool isPizza = false}) {
    return SizedBox(
      width: width,
      height: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryOrange),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: isPizza ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Image.asset(
              icon,
              width: isPizza ? 24 : null,
              height: isPizza ? 24 : null,
              fit: isPizza ? BoxFit.contain : null,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: AppStrings.dmSansFont,
                fontWeight: FontWeight.w700,
                height: 1.0,
                letterSpacing: -0.54,
              ),
            ),
          ],
        ),
      ),
    );
  }

// TODO:: CONTENT AREA WIDGET
  Widget _buildContentArea(
      AsyncValue<List<Map<String, dynamic>>> foodsAsync,
      ) {
    return foodsAsync.when(
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
      data: (foods) {
        return SizedBox(
          height: 970,
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: TabBarView(
              children: [
                _buildFoodGrid(
                  foods,
                  AppStrings.burger,
                  _searchController.text,
                ),
                _buildFoodGrid(
                  foods,
                  AppStrings.pizza,
                  _searchController.text,
                ),
                _buildFoodGrid(
                  foods,
                  AppStrings.sandwich,
                  _searchController.text,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // TODO:: FOOD GRID WIDGET
  Widget _buildFoodGrid(
      List<Map<String, dynamic>> foods,
      String category,
      String searchQuery,
      ) {
    final query = searchQuery.toLowerCase();

    final categoryFoods = foods
        .where((food) {
      final foodCategory =
          food[AppStrings.keyCategory]?.toString() ?? '';

      final title =
          food[AppStrings.keyTitle]?.toString().toLowerCase() ?? '';

      final description =
          food[AppStrings.keyDescription]?.toString().toLowerCase() ?? '';

      return foodCategory == category &&
          (title.contains(query) || description.contains(query));
    })
        .toList();

    if (categoryFoods.isEmpty) {
      return const Center(
        child: Text(
          AppStrings.noFoodFound,
          style: TextStyle(
            fontFamily: AppStrings.robotoFont,
            fontSize: 16,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryFoods.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        mainAxisExtent: 207,
      ),
      itemBuilder: (context, index) =>
          _buildFoodCard(categoryFoods[index], index),
    );
  }

  // TODO:: FOOD CARD WIDGET
  Widget _buildFoodCard(Map<String, dynamic> food, int index) {
    return AnimatedCards(
      index: index,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Description(food: food),
            ),
          );
        },
        child: Container(
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
              // Rating Row
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.starYellow, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    food[AppStrings.keyRating].toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppStrings.dmSansFont,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Food Image
              Center(
                child: SizedBox(
                  height: 72,
                  child: Image.asset(
                    food[AppStrings.keyImage].toString(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // Title
              Text(
                food[AppStrings.keyTitle].toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppStrings.dmSansFont,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),

              // Description
              Text(
                food[AppStrings.keyDescription].toString(),
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

              // Price and Add Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$ ${(food[AppStrings.keyPrice] as num).toDouble().toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            letterSpacing: -0.42,
                            color: AppColors.primaryOrange,
                            fontFamily: AppStrings.dmSansFont,
                          ),
                        ),
                        const TextSpan(
                          text: '.00',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                            letterSpacing: -0.3,
                            color: AppColors.primaryOrange,
                            fontFamily: AppStrings.dmSansFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: AppColors.white, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TODO:: BOTTOM NAVIGATION BAR WIDGET
  Widget _buildBottomNavigationBar() {
    return Container(
      width: double.infinity,
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.10),
            offset: const Offset(0, -5),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(AppStrings.homeIcon),
          Image.asset(AppStrings.lockIcon),
          Image.asset(AppStrings.dots3Icon),
        ],
      ),
    );
  }
}
