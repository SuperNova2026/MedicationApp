import 'dart:convert';
import 'dart:io';
import '../models/intake.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


var serverUrl = Platform.isAndroid ? "10.0.2.2" : "127.0.0.1";
var serverPort = "8000";


class IntakeModel with ChangeNotifier {
  List<Intake> intakes = [];
  int id = 0;
  int medicationId = 0;
  String date = "";
  int patientId = 0;
  int intakeCount = 0;
  int startIndex = 0;
  int count = 10;
  String? errorMessage;
  bool isLoading = false;
  bool hasMoreIntakes = true;
  Intake? selectedIntake;

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
          hasMoreIntakes = false;
        } else {
          startIndex = startIndex + count;
        }
        intakes.addAll(
            List<Intake>.from(data.map((item) => Intake.fromJson(item))));
      } else {
        errorMessage = "Invalid data";
      }
    } on http.ClientException {
      errorMessage = "Service is not available. Try again later.";
    }
    isLoading = false;
    notifyListeners();
  }

  Future<Intake> getPatientData(int id) async {
        var uri = Uri.http(
        "$serverUrl:$serverPort", "patients/$patientId/medications/$medicationId/intakes/");
    try {
      print("aqui $uri");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Intake.fromJson(data);
      } else {
        throw Exception(response.body);
      }
    } on http.ClientException {
      throw http.ClientException("Service is not available. Try again later.");
    }
  }
}


