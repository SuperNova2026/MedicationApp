import 'dart:convert';
import 'dart:io';
import '../models/medication.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/patient_provider.dart';
import 'package:provider/provider.dart';

var serverUrl = Platform.isAndroid ? "10.0.2.2" : "127.0.0.1";
var serverPort = "8000";

class MedicationModel with ChangeNotifier {
  List<Medication> medications = [];
  String? errorMessage;
  bool isLoading = false;
  Medication? selectedMedication;

  // Cargar las medicaciones para el paciente logueado
  Future<void> loadMedications(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Obtén el ID del paciente logueado desde el PatientModel
    final patientModel = Provider.of<PatientModel>(context, listen: false);
    final patientId = patientModel.selectedPatient?.id;

    if (patientId == null) {
      errorMessage = "No se ha seleccionado un paciente.";
      isLoading = false;
      notifyListeners();
      return;
    }

    var uri = Uri.http(
      "$serverUrl:$serverPort",
      "patients/$patientId/medications",
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));

        // Mapeo y filtro de medicaciones activas
        medications = List<Medication>.from(
          data.map((item) => Medication.fromJson(item)).where((medication) {
            final startDate = DateTime.parse(medication.startDate);
            final endDate = startDate.add(Duration(days: medication.treatmentDuration));
            return endDate.isAfter(DateTime.now()); // Filtra medicaciones activas
          }),
        );

        notifyListeners();
      } else {
        errorMessage = "Failed to load medications.";
        notifyListeners();
      }
    } on http.ClientException {
      errorMessage = "Service is not available. Try again later.";
    }
    isLoading = false;
    notifyListeners();
  }

  // Obtener datos de una medicación específica
  Future<Medication> getMedicationData(BuildContext context, int id) async {
    final patientModel = Provider.of<PatientModel>(context, listen: false);
    final patientId = patientModel.selectedPatient?.id;

    if (patientId == null) {
      throw Exception("No se ha seleccionado un paciente.");
    }

    var uri = Uri.http("$serverUrl:$serverPort", "patients/$patientId/medications/$id");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        return Medication.fromJson(data);
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Service is not available. Try again later.");
    }
  }
}
