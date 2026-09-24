import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class DescriptionState {
  final int quantity;
  final File? selectedImage;
  final DateTime? selectedDate;

  const DescriptionState({
    this.quantity = 1,
    this.selectedImage,
    this.selectedDate,
  });

  DescriptionState copyWith({
    int? quantity,
    File? selectedImage,
    DateTime? selectedDate,
  }) {
    return DescriptionState(
      quantity: quantity ?? this.quantity,
      selectedImage: selectedImage ?? this.selectedImage,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class DescriptionNotifier extends Notifier<DescriptionState> {
  @override
  DescriptionState build() {
    return const DescriptionState();
  }

  // TODO:: INCREASE QUANTITY
  void increaseQuantity() {
    state = state.copyWith(
      quantity: state.quantity + 1,
    );
  }

  // TODO:: DECREASE QUANTITY
  void decreaseQuantity() {
    if (state.quantity > 1) {
      state = state.copyWith(
        quantity: state.quantity - 1,
      );
    }
  }

  // TODO:: SELECT IMAGE
  void selectImage(File image) {
    state = state.copyWith(
      selectedImage: image,
    );
  }

  // TODO:: SELECT DELIVERY DATE
  void selectDate(DateTime date) {
    state = state.copyWith(
      selectedDate: date,
    );
  }
}

// TODO:: DESCRIPTION PROVIDER
final descriptionProvider =
NotifierProvider<DescriptionNotifier, DescriptionState>(
  DescriptionNotifier.new,
);