import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Description extends StatefulWidget {

  final Map<String, dynamic> food;

  const Description({
    super.key,
    required this.food,
  });

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  int quantity = 1;
  File? selectedImage;
  DateTime? selectedDate;
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final food = widget.food;

    final String title = food['title'] ?? 'Food Item';
    final String furtherDescription = food['further_description'] ?? '';
    final String image = food['image'] ?? '';
    final double rating = (food['rating'] ?? 0).toDouble();
    final num price = food['price'] ?? 0;
    final double totalPrice = price.toDouble() * quantity;

    return Scaffold(
      backgroundColor: const Color(0xFFFDECDA),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    image,
                    height: 210,
                    width: 262,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.fastfood,
                        size: 100,
                        color: Colors.amber,
                      );
                    },
                  ),
                ),


                Positioned(
                  top: 40,
                  left: 25,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/back.png',
                    ),
                  ),
                ),

                Positioned(
                  top: 40,
                  right: 25,
                  child: Image.asset(
                    'assets/like.png',
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 20,
                    child: Image.asset(
                      'assets/dots.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DM Sans',
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFC107),
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'DM Sans',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '(41 Reviews)',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'DM Sans',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            '\$ ${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF9431),
                              fontFamily: 'DM Sans',
                            ),
                          ),



                          Container(
                            width: 118,
                            height: 48,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0E3),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [


                                GestureDetector(
                                  onTap: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF9431),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),


                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'DM Sans',
                                    color: Colors.black,
                                  ),
                                ),



                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF9431),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [


                          Container(
                            width: 93.6,
                            height: 65,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFFF9431),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Size',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFFF9431),
                                        fontFamily: 'DM Sans',
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFFFF9431),
                                      size: 20,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Text(
                                  'Medium',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'DM Sans',
                                  ),
                                ),
                              ],
                            ),
                          ),


                          Container(
                            width: 93.6,
                            height: 65,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFFF9431),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Energy',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFF9431),
                                    fontFamily: 'DM Sans',
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '554 KCal',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'DM Sans',
                                  ),
                                ),
                              ],
                            ),
                          ),



                          Container(
                            width: 93.6,
                            height: 65,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFFF9431),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Delivery',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFF9431),
                                    fontFamily: 'DM Sans',
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '45 min',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'DM Sans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),


                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DM Sans',
                        ),
                      ),

                      const SizedBox(height: 10),




                      const SizedBox(height: 8),

//  FURTHER DESCRIPTION
                      Text(
                        furtherDescription,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'DM Sans',
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 30),
                      const SizedBox(height: 20),


                    Center(child:
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          height: 61,
                          width:327,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0E3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFF9431),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image,
                                color: Color(0xFFFF9431),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                selectedImage == null
                                    ? 'Choose Image'
                                    : 'Image Selected',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'DM Sans',
                                  color: Color(0xFFFF9431),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                      const SizedBox(height: 15),


                      Center(child:GestureDetector(
                        onTap: pickDate,
                        child: Container(
                          width: 327,
                          height: 61,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0E3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFF9431),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Color(0xFFFF9431),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                selectedDate == null
                                    ? 'Select Delivery Date'
                                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'DM Sans',
                                  color: Color(0xFFFF9431),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),),

                      const SizedBox(height: 30),




                      Center(
                        child: Container(
                          width: 327,
                          height: 61,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9431),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
