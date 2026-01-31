import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final int id;
  final String name;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.isChecked,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: const TextStyle(color: Color(0xFF3F3BA3), fontWeight: FontWeight.bold)),
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: const Color(0xFF3F3BA3),
        ),
      ],
    );
  }
}