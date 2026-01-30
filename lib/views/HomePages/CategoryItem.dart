import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  final int id;
  final bool is_active;
  final String name;

  const CategoryItem({
    required this.id,
    required this.is_active,
    required this.name,
    super.key,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.is_active;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3F3BA3),
            ),
          ),
          Checkbox(
            value: isChecked,
            activeColor: const Color(0xFF3F3BA3),
            onChanged: (bool? value) {
              if (value != null) {
                setState(() {
                  isChecked = value;
                });
                print("ID: ${widget.id}, Status: $isChecked");
              }
            },
          ),
        ],
      ),
    );
  }
}