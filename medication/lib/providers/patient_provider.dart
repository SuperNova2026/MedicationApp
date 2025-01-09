import 'dart:convert';
import 'dart:io';
import '../models/patient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var serverUrl = Platform.isAndroid ? "10.0.2.2" : "127.0.0.1";
var serverPort = "8000";

class PatientModel with ChangeNotifier {
  Patient? _selectedPatient;
  String? errorMessage;
  bool isLoading = false;

  // Getter para obtener el paciente seleccionado
  Patient? get selectedPatient => _selectedPatient;

  // Setter para definir el paciente seleccionado
  set selectedPatient(Patient? patient) {
    _selectedPatient = patient;
    notifyListeners();
  }

  // Método para limpiar el paciente seleccionado (Logout)
  void logout() {
    _selectedPatient = null;
    notifyListeners();
  }

  // Verificar si un código existe
  Future<bool> getCodeExist(String code) async {
    final uri = Uri.http("$serverUrl:$serverPort", "patients", {"code": code});
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data.isNotEmpty;
      } else {
        errorMessage = "Error al validar el código.";
        return false;
      }
    } catch (e) {
      errorMessage = "Error de conexión.";
      return false;
    }
  }

  // Obtener paciente por código
  Future<Patient?> getPatientByCode(String code) async {
    final uri = Uri.http("$serverUrl:$serverPort", "patients", {"code": code});
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return Patient.fromJson(data);
      } else {
        errorMessage = "Error al buscar el paciente.";
        return null;
      }
    } catch (e) {
      errorMessage = "Error de conexión.";
      return null;
    }
  }
}
