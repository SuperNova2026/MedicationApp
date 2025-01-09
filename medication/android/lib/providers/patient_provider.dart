import 'dart:convert';
import 'dart:io';
import '../models/medication.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/patient.dart';

var serverUrl = Platform.isAndroid ? "10.0.2.2" : "127.0.0.1";
var serverPort = "8000";

class PatientModel with ChangeNotifier {
  List<Patient> patients = [];
  int startIndex = 0;
  int count = 10;
  int patientCount = 0;
  String? errorMessage;
  bool isLoading = false;
  bool hasMorePatients = true;
  Patient? selectedPatient;

  Future<void> loadPatients() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    var uri = Uri.http("$serverUrl:$serverPort", "patients", {
      'start_index': "$startIndex",
      'count': "$count"
    });

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.isEmpty) {
          hasMorePatients = false;
        } else {
          startIndex += count;
        }
        patients.addAll(List<Patient>.from(data.map((item) => Patient.fromJson(item))));
      } else {
        errorMessage = "Invalid data";
      }
    } on http.ClientException {
      errorMessage = "Service is not available. Try again later.";
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleStarred(Patient patient) {
    patient.starred = !patient.starred;
    notifyListeners();
  }

  Future<Patient> getPatientData(int id) async {
    var uri = Uri.http("$serverUrl:$serverPort", "patients/$id");
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Patient.fromJson(data);
      } else {
        throw Exception(response.body);
      }
    } on http.ClientException {
      throw http.ClientException("Service is not available. Try again later.");
    }
  }

  Future<Patient?> getPatientByCode(String code) async {
    var uri = Uri.http("$serverUrl:$serverPort", "patients", {"code": code});
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.isNotEmpty) {
          return Patient.fromJson(data[0]);
        } else {
          throw Exception("No patient found with this code.");
        }
      } else {
        throw Exception("Failed to load patient.");
      }
    } catch (e) {
      throw Exception("Service is not available. Try again later.");
    }
  }

  Future<List<Medication>> getMedicationsByPatientId(int patientId) async {
    var uri = Uri.http("$serverUrl:$serverPort", "patients/$patientId/medications");
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return List<Medication>.from(data.map((item) => Medication.fromJson(item)));
      } else {
        throw Exception("Failed to load medications.");
      }
    } catch (e) {
      throw Exception("Service is not available. Try again later.");
    }
  }



}


class PatientProvider with ChangeNotifier {
  Patient? _patient;
  List<Medication> _medications = [];

  Patient? get patient => _patient;
  List<Medication> get medications => _medications;

  // Fetch patient by code
  Future<Patient?> fetchPatientByCode(String code) async {
    final uri = Uri.http('0.0.0.0:8000', '/patients', {'code': code});
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          _patient = Patient.fromJson(data[0]);
          await fetchMedicationsByPatientId(_patient!.id);
          notifyListeners();
          return _patient;
        }
      }
    } catch (e) {
      print("Error fetching patient: $e");
    }
    return null;
  }

  // Fetch medications by patient ID
  Future<void> fetchMedicationsByPatientId(int patientId) async {
    final uri = Uri.http('0.0.0.0:8000', '/patients/$patientId/medications');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _medications = data.map((item) => Medication.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching medications: $e");
    }
  }
}



