// lib/core/widgets/input_box.dart
import 'package:flutter/material.dart';

Widget buildInputBox() {
  return TextField(
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF3F3F3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    ),
  );
}
