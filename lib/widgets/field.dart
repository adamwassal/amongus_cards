import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  const Field({super.key, required this.label, this.controller, this.keyboardType, this.function, this.focus, this.color, this.onChanged});
  final String label;
  final bool? focus;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? function;
  final ValueChanged<String>? onChanged;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        style: TextStyle(color: color ?? Colors.white),
        onSubmitted: function,
        onChanged: onChanged,
        autofocus: focus ?? false,

        decoration: InputDecoration(
          labelStyle: TextStyle(color: color ?? Colors.white),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: color ?? Colors.white),
            
          ),
        ),
      ),
    );
  }
}
