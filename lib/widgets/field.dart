import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  const Field({super.key, required this.label, this.controller, this.keyboardType});
  final String label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        style: const TextStyle(color: Colors.white),

        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.white),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white),
            
          ),
        ),
      ),
    );
  }
}
