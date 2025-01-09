import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class IntakesPage extends StatelessWidget {
  const IntakesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("My intakes"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textColorLight,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text(
            'Página de Ingestas',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
