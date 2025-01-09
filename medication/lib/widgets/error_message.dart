import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontSize: 16)),
    );
  }
}
