import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'food_Description.dart';
import 'animated_food_cart.dart';

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
      print('🔥 Starting Firebase fetch...');

      final startTime = DateTime.now();

      final snapshot = await FirebaseFirestore.instance
          .collection('foods')
          .get();

      final endTime = DateTime.now();

      print(
        '🔥 Firebase fetch completed in '
            '${endTime.difference(startTime).inMilliseconds} ms',
      );

      print('🔥 Documents received: ${snapshot.docs.length}');

      if (!mounted) return;

      setState(() {
        _allFoods = snapshot.docs
            .map((doc) => doc.data())
            .toList();

        _isLoading = false;
      });
    } catch (e) {
      print('🔥 Firebase ERROR: $e');

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
          (food) => food['category']?.toString() == category,
    )
        .toList();

    if (foods.isEmpty) {
      return const Center(
        child: Text(
          'No food found',
          style: TextStyle(
            fontFamily: 'Roboto',
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
                  color: Color(0xFFFFC107),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  food['rating'].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Center(
              child: SizedBox(
                height: 72,
                child: Image.asset(
                  food['image'].toString(),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              food['title'].toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'DM Sans',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 2),

            Text(
              food['description'].toString(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontFamily: 'DM Sans',
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
                  '\$ ${(food['price'] as num).toDouble().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9431),
                    fontFamily: 'DM Sans',
                  ),
                ),

                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9431),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
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
          backgroundColor: Colors.white,

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
                      Image.asset('assets/Location.png'),

                      const SizedBox(width: 8),

                      const Text(
                        ' Naveda, US ',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Image.asset(
                        'assets/down_arrow.png',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Text(
                          "Order Your Food\nFast and Free",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 28,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Image.asset(
                        'assets/delivery 1.png',
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
                            hintText: 'Search',
                            contentPadding:
                            const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            hintStyle: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: Color(0xFFCCCCCC),
                            ),
                            prefixIcon: Image.asset(
                              'assets/Search.png',
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(
                                color: Color(0xFFE6E6E6),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Image.asset(
                          'assets/SearchFront.png',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: Colors.black,
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
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding:
                    const EdgeInsets.only(right: 5),
                    indicator: BoxDecoration(
                      color: const Color(0xFFFF9431),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,

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
                                const Color(0xFFFF9431),
                              ),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/burger.png',
                                ),

                                const SizedBox(width: 16),

                                const Text(
                                  'Burger',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
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
                                const Color(0xFFFF9431),
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
                                    'assets/pizza.png',
                                  ),
                                ),

                                const SizedBox(width: 8),

                                const Text(
                                  'Pizza',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
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
                              const Color(0xFFFF9431),
                            ),
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/sandwich.png',
                              ),

                              const SizedBox(width: 8),

                              const Text(
                                'Sandwich',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Roboto',
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
                          color: Color(0xFFFF9431),
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
                              fontFamily: 'Roboto',
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 970,
                        child: Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: TabBarView(
                            children: [
                              foodTab('Burger'),
                              foodTab('Pizza'),
                              foodTab('Sandwich'),
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
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
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
            Image.asset('assets/home.png'),
            Image.asset('assets/lock.png'),
            Image.asset('assets/3dots.png'),
          ],
        ),
      ),
      ),
    );

  }
}