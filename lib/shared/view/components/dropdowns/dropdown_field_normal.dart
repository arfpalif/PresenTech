import 'package:flutter/material.dart';
import 'package:presentech/configs/themes/themes.dart';

class DropdownFieldNormal<T> extends StatelessWidget {
  const DropdownFieldNormal({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.decoration,
    this.labelBuilder,
  });

  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final InputDecoration? decoration;
  final String Function(T)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            labelBuilder != null ? labelBuilder!(item) : item.toString(),
            style: AppTextStyle.normal,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration:
          decoration ??
          InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyle.normal.copyWith(color: Colors.grey),
          ),
      style: AppTextStyle.normal,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
    );
  }
}
