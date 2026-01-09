import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateController extends GetxController {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final selectedDate = Rx<DateTime?>(null);

  void pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate.value = picked;
      startDateController.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  void pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate.value = picked;
      endDateController.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }
}
