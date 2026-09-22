import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'utils/colors.dart';
import 'utils/strings.dart';

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

  // TODO:: PICK IMAGE FROM GALLERY
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

  // TODO:: PICK DELIVERY DATE
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

  // TODO:: MAIN BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPeach,
      body: Column(
        children: [
          // Top section with image and header buttons
          _buildTopSection(),

          // Bottom section with scrollable details
          _buildBottomSection(),
        ],
      ),
    );
  }

  // TODO:: TOP SECTION (IMAGE AND BUTTONS)
  Widget _buildTopSection() {
    final String image = widget.food[AppStrings.keyImage] ?? '';

    return Expanded(
      flex: 4,
      child: Stack(
        children: [
          // Center Food Image
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
                  color: AppColors.amber,
                );
              },
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 25,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(AppStrings.backIcon),
            ),
          ),

          // Like Button
          Positioned(
            top: 40,
            right: 25,
            child: Image.asset(AppStrings.likeIcon),
          ),

          // Pagination Dots
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 20,
              child: Image.asset(
                AppStrings.dotsIcon,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TODO:: BOTTOM SECTION (FOOD DETAILS)
  Widget _buildBottomSection() {
    return Expanded(
      flex: 6,
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.white,
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
                // Title and Rating
                _buildTitleAndRating(),
                const SizedBox(height: 18),

                // Price and Quantity
                _buildPriceAndQuantity(),
                const SizedBox(height: 25),

                // Info Cards Row
                _buildInfoCards(),
                const SizedBox(height: 25),

                // About Section
                _buildAboutSection(),
                const SizedBox(height: 30),

                // Selection Buttons (Image, Date, Add to Cart)
                _buildActionButtons(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TODO:: TITLE AND RATING ROW
  Widget _buildTitleAndRating() {
    final String title = widget.food[AppStrings.keyTitle] ?? AppStrings.defaultFoodTitle;
    final double rating = (widget.food[AppStrings.keyRating] ?? 0).toDouble();

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: AppStrings.dmSansFont,
            ),
          ),
        ),
        const Icon(
          Icons.star,
          color: AppColors.starYellow,
          size: 24,
        ),
        const SizedBox(width: 2),
        Text(
          rating.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontFamily: AppStrings.dmSansFont,
            color: AppColors.black,
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          AppStrings.reviewsCount,
          style: TextStyle(
            fontSize: 12,
            fontFamily: AppStrings.dmSansFont,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  // TODO:: PRICE AND QUANTITY ROW
  Widget _buildPriceAndQuantity() {
    final num price = widget.food[AppStrings.keyPrice] ?? 0;
    final double totalPrice = price.toDouble() * quantity;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Rich Text Price
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${AppStrings.dollarSign}${totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: AppStrings.dmSansFont,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  height: 1.0,
                  letterSpacing: -0.72,
                  color: AppColors.primaryOrange,
                ),
              ),
              const TextSpan(
                text: '.00',
                style: TextStyle(
                  fontFamily: AppStrings.dmSansFont,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  height: 1.0,
                  letterSpacing: -0.54,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
        ),

        // Quantity Selector
        _buildQuantitySelector(),
      ],
    );
  }

  // TODO:: QUANTITY SELECTOR
  Widget _buildQuantitySelector() {
    return Container(
      width: 118,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Decrement
          GestureDetector(
            onTap: () {
              if (quantity > 1) {
                setState(() => quantity--);
              }
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove,
                color: AppColors.white,
                size: 25,
              ),
            ),
          ),

          // Quantity Text
          Text(
            quantity.toString(),
            style: const TextStyle(
              fontSize: 22,
              fontFamily: AppStrings.dmSansFont,
              color: AppColors.black,
            ),
          ),

          // Increment
          GestureDetector(
            onTap: () => setState(() => quantity++),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TODO:: INFO CARDS (SIZE, ENERGY, DELIVERY)
  Widget _buildInfoCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoCard(AppStrings.sizeLabel, AppStrings.mediumSize, isSize: true),
        _buildInfoCard(AppStrings.energyLabel, AppStrings.defaultEnergy),
        _buildInfoCard(AppStrings.deliveryLabel, AppStrings.defaultDeliveryTime),
      ],
    );
  }

  // TODO:: INDIVIDUAL INFO CARD WIDGET
  Widget _buildInfoCard(String label, String value, {bool isSize = false}) {
    return Container(
      width: 93.6,
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryOrange, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryOrange,
                  fontFamily: AppStrings.dmSansFont,
                ),
              ),
              if (isSize)
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primaryOrange,
                  size: 20,
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.54,
              color: AppColors.black,
              fontFamily: AppStrings.dmSansFont,
            ),
          ),
        ],
      ),
    );
  }

  // TODO:: ABOUT SECTION
  Widget _buildAboutSection() {
    final String furtherDescription = widget.food[AppStrings.keyFurtherDescription] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.aboutLabel,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: AppStrings.dmSansFont,
          ),
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 8),
        Text(
          furtherDescription,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppStrings.dmSansFont,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  // TODO:: ACTION BUTTONS (IMAGE, DATE, ADD TO CART)
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Image Picker
        _buildPickerButton(
          onTap: pickImage,
          icon: Icons.image,
          label: selectedImage == null ? AppStrings.chooseImage : AppStrings.imageSelected,
        ),
        const SizedBox(height: 15),

        // Date Picker
        _buildPickerButton(
          onTap: pickDate,
          icon: Icons.calendar_month,
          label: selectedDate == null
              ? AppStrings.selectDeliveryDate
              : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
        ),
        const SizedBox(height: 30),

        // Add to Cart Button
        Center(
          child: Container(
            width: 327,
            height: 61,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                AppStrings.addToCart,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontFamily: AppStrings.dmSansFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // TODO:: HELPER FOR IMAGE/DATE PICKER BUTTONS
  Widget _buildPickerButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
  }) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 61,
          width: 327,
          decoration: BoxDecoration(
            color: AppColors.peach,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryOrange),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primaryOrange),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: AppStrings.dmSansFont,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
