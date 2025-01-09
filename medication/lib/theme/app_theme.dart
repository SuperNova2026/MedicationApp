import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 112, 145, 190),
      brightness: Brightness.light,
    ),
  );

  // Colores y estilos comunes
  static const Color primaryColor = Color.fromARGB(255, 112, 145, 190);
  static const Color errorColor = Color.fromARGB(255, 173, 68, 68);
  static const Color backgroundColor = Colors.white;
  static const Color textColorDark = Colors.black87;
  static const Color textColorLight = Colors.white;

  // Estilos reutilizables
  static const TextStyle tileTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blueAccent,
  );

  // Estilos reutilizables
  static const TextStyle tileSubtitleStyle = TextStyle(
    fontSize: 18,
    color: textColorDark,
    fontWeight: FontWeight.bold,
  );

  static const EdgeInsets tilePadding = EdgeInsets.all(16.0);
}




