import 'package:flutter/material.dart';

import '../../constants/Constant.dart';
Widget buildTag(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Constant.keyTextBackColor,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 5),
        Container(
          width: 15,
          height: 15,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.clear, color: Colors.white, size: 13),
        ),
      ],
    ),
  );
}
