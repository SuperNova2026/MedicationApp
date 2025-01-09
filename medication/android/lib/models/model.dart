
/*
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var serverUrl = Platform.isAndroid ? "10.0.2.2" : "127.0.0.1";
var serverPort = "8000";

class Patient {
  Patient(this.id, this.code, this.name, this.surname);
  final int id;
  final String code;
  final String name;
  final String surname;
  bool starred = false;

  Patient.fromJson(Map json)
      : id = json["id"],
        name = json["name"],
        surname = json["surname"],
        code = json["code"],
        starred = false;

  @override
  String toString() {
    return "$id | $code | $name $surname";
  }
}

class PatientModel with ChangeNotifier {
  List<Patient> patients = [];
  int patientCount = 0;
  int startIndex = 0;
  int count = 10;
  String? errorMessage;
  bool isLoading = false;
  bool hasMorePatients = true;
  Patient? selectedPatient;

  void loadPatients() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    var uri = Uri.http("$serverUrl:$serverPort", "patients",
        {'start_index': "$startIndex", 'count': "$count"});
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.isEmpty) {
          hasMorePatients = false;
        } else {
          startIndex = startIndex + count;
        }
        patients.addAll(
            List<Patient>.from(data.map((item) => Patient.fromJson(item))));
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
      print("aqui $uri");
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
}


 */
