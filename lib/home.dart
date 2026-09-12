import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'food_Description.dart';
import 'animated_food_cart.dart';
import 'utils/colors.dart';
import 'utils/strings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _allFoods = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  // Load all foods from Firebase only once
  Future<void> _loadFoods() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(AppStrings.foodsCollection)
          .get();

      if (!mounted) return;

      setState(() {
        _allFoods = snapshot.docs
            .map((doc) => doc.data())
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }


  // Filter already loaded data according to category
  Widget foodTab(String category) {
    final foods = _allFoods
        .where(
          (food) => food[AppStrings.keyCategory]?.toString() == category,
    )
        .toList();

    if (foods.isEmpty) {
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
      itemCount: foods.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        mainAxisExtent: 207,
      ),
itemBuilder: (context, index) {
  final food = foods[index];

  return AnimatedCards(
    index: index,
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Description(
                  food: food,
                ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          12,
          8,
          12,
          8,
        ),
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
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: AppColors.starYellow,
                  size: 16,
                ),
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

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                Text(
                  '\$ ${(food[AppStrings.keyPrice] as num).toDouble().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryOrange,
                    fontFamily: AppStrings.dmSansFont,
                  ),
                ),

                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
},
    );
  }



    @override
  Widget build(BuildContext context)
    {
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
                  Row(
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

                      Image.asset(
                        AppStrings.downArrowIcon,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
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

                      Image.asset(
                        AppStrings.deliveryIcon,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: AppStrings.searchHint,
                            contentPadding:
                            const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            hintStyle: const TextStyle(
                              fontFamily: AppStrings.robotoFont,
                              fontSize: 16,
                              color: AppColors.searchHint,
                            ),
                            prefixIcon: Image.asset(
                              AppStrings.searchIcon,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(
                                color: AppColors.searchBorder,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Image.asset(
                          AppStrings.searchFrontIcon,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    AppStrings.categories,
                    style: TextStyle(
                      fontFamily: AppStrings.robotoFont,
                      fontSize: 18,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.zero,
                    labelPadding:
                    const EdgeInsets.only(right: 5),
                    dividerColor: AppColors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding:
                    const EdgeInsets.only(right: 5),
                    indicator: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.black,

                    tabs: [
                      Padding(
                        padding:
                        const EdgeInsets.only(right: 5),
                        child: SizedBox(
                          width: 140,
                          height: 40,
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                AppColors.primaryOrange,
                              ),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  AppStrings.burgerIcon,
                                ),

                                const SizedBox(width: 16),

                                const Text(
                                  AppStrings.burger,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: AppColors.black,
                                    fontFamily: AppStrings.robotoFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.only(right: 5),
                        child: SizedBox(
                          width: 123,
                          height: 40,
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                AppColors.primaryOrange,
                              ),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: 2,
                                  child: Image.asset(
                                    AppStrings.pizzaIcon,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                const Text(
                                  AppStrings.pizza,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: AppColors.black,
                                    fontFamily: AppStrings.robotoFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 160,
                        height: 40,
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                              AppColors.primaryOrange,
                            ),
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                AppStrings.sandwichIcon,
                              ),

                              const SizedBox(width: 8),

                              const Text(
                                AppStrings.sandwich,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                  color: AppColors.black,
                                  fontFamily: AppStrings.robotoFont,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),



                  if (_isLoading)
                    const SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    )
                  else
                    if (_error != null)
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            'Error: $_error',
                            style: const TextStyle(
                              fontFamily: AppStrings.robotoFont,
                              color: AppColors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 970,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: TabBarView(
                            children: [
                              foodTab(AppStrings.burger),
                              foodTab(AppStrings.pizza),
                              foodTab(AppStrings.sandwich),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ),

        ),

        bottomNavigationBar: Container(
        width: double.infinity,
        height: 84,
        padding:
        const EdgeInsets.symmetric(horizontal: 48),
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
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(AppStrings.homeIcon),
            Image.asset(AppStrings.lockIcon),
            Image.asset(AppStrings.dots3Icon),
          ],
        ),
      ),
      ),
    );

  }
}