import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptativeTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final void Function(String) onSubmitted;
  final TextInputType keyboardType;

  const AdaptativeTextField({
    required this.label,
    required this.controller,
    required this.onSubmitted,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: CupertinoTextField(
              controller: controller,
              onSubmitted: onSubmitted,
              keyboardType: keyboardType,
              placeholder: label,
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
            ),
          )
        : TextField(
            // entrada de texto
            controller: controller,
            onSubmitted: onSubmitted, // confirma a entrada
            decoration: InputDecoration(labelText: label),
            keyboardType: keyboardType,
          );
  }
}
