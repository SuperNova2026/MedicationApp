import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textColorLight,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text(
            'Página de notificaciones',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
