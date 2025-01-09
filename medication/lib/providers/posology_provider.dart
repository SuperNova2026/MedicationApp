import 'dart:convert';
import 'dart:io';
import 'package:mypatients/providers/medication_provider.dart';
import 'package:mypatients/providers/patient_provider.dart';
import 'package:provider/provider.dart';

import '../models/medication.dart';
import '../models/posology.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


var serverUrl = Platform.isAndroid ? "10.0.2.2" : "127.0.0.1";
var serverPort = "8000";

class PosologyModel with ChangeNotifier {
  List<Medication> medicationlist = [];
  List<Posology> posologies = [];
  String date = "";
  String? errorMessage;
  bool isLoading = false;

  Future<void> loadPosologies(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final patientModel = Provider.of<PatientModel>(context, listen: false);
    final patientId = patientModel.selectedPatient?.id;
    final medicationModel = Provider.of<MedicationModel>(
        context, listen: false);
    await medicationModel.loadMedications(context);
    final medications = medicationModel.medications;
    medicationlist = medications;
    for (var medication in medications) {
      var medicationId = medication.id;
      var uri = Uri.http(
          "$serverUrl:$serverPort",
          "patients/$patientId/medications/$medicationId/posologies");
      try {
        var response = await http.get(uri);
        if (response.statusCode == 200) {
          var data = json.decode(utf8.decode(response.bodyBytes));
          posologies.addAll(
              List<Posology>.from(data.map((item) => Posology.fromJson(item))));
        } else {
          errorMessage = "Failed to load posologies.";
        }
      } on http.ClientException {
        errorMessage = "Service is not available. Try again later.";
      }
    }
    isLoading = false;
    notifyListeners();
  }


  Future<void> loadPosologiesPeriodic(BuildContext context, int period) async {
    isLoading = true; // Activar indicador de carga
    errorMessage = null;

    // Limpiar listas antes de cualquier operación
    posologies = [];
    medicationlist = [];
    notifyListeners(); // Notificar que las listas están vacías

    try {
      // Cargar todas las posologías disponibles
      await loadPosologies(context);

      List<Posology> filteredPosologies = []; // Lista temporal para filtrar
      List<Posology> filteredPosologiesManhana= []; //Lista temporal para ordenar
      DateTime currentTime = DateTime.now();

      for (var posology in posologies) {
        // Crear la fecha y hora completa de la posología
        DateTime posologyDateTime = DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          posology.hour,
          posology.minute,
        );

        // Ajustar al día siguiente si la hora ya pasó hoy
        if (posologyDateTime.isBefore(currentTime)) {
          posologyDateTime = posologyDateTime.add(const Duration(days: 1));
        }

        // Verificar si la posología está dentro del rango de tiempo seleccionado
        if (posologyDateTime.isBefore(currentTime.add(Duration(hours: period)))) {
          if (posologyDateTime.hour>currentTime.hour) { //Posologias de hoy
            filteredPosologies.add(posology);
          }
          else{
            filteredPosologiesManhana.add(posology); //Posologias de mañana
          }
        }
      }
      filteredPosologies.sort((a, b) => a.hour.compareTo(b.hour));
      filteredPosologiesManhana.sort((a, b) => a.hour.compareTo(b.hour));

      filteredPosologies.addAll(filteredPosologiesManhana);
      // Eliminar duplicados usando Set y volver a List
      posologies = filteredPosologies.toSet().toList();

    } catch (e) {
      // Capturar errores
      errorMessage = "Error al cargar o filtrar posologías: $e";
    } finally {
      // Finalizar carga y notificar cambios
      isLoading = false;
      notifyListeners();
    }
  }


  String getMedicationNameByPosology(int posologyId){
    try {
      isLoading=true;
      final posology = posologies.firstWhere(
            (pos) => pos.id == posologyId,
      );

      final medication = medicationlist.firstWhere(
            (med) => med.id == posology.medicationId,
        );
      isLoading=false;
      return '${medication.name}\nDosage: ${medication.dosage}';

    } catch (e) {
      isLoading=false;
      return "$e";
    }
  }
  Future<String> registerIntake(BuildContext context, int posologyId) async {
    String respuesta ="Error desconocido";
    try {
      isLoading = true;
      notifyListeners();

      Posology? posology = getLoadedPosologyById(posologyId);
      final patientModel = Provider.of<PatientModel>(context, listen: false);
      final patientId = patientModel.selectedPatient?.id;

      if (posology == null || patientId == null) {
        throw Exception("Posología o paciente no encontrados.");
      }

      var uri = Uri.http(
          "$serverUrl:$serverPort",
          "/patients/$patientId/medications/${posology.medicationId}/intakes/"
      );

      DateTime date = DateTime.now();

      // Codificación JSON correcta
      var body = json.encode({
        'medication_id': posology.medicationId,
        'date': date.toIso8601String().substring(0, 16), // Formato hasta minutos
      });

      // Realizar la solicitud HTTP POST
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        // Si el servidor devuelve un código de estado 200, éxito.
        respuesta = ('Intake registrado correctamente');

      } else if (response.statusCode == 307) {
        // Si hay un error 307 (Redirección Temporal)
        final newLocation = response.headers['location'];
        if (newLocation != null) {
          // Si hay un encabezado de ubicación, realiza una nueva solicitud a la URL redirigida.
          final newResponse = await http.post(
            Uri.parse(newLocation),
            headers: {
              'Content-Type': 'application/json',
            },
            body: body,
          );
          if (newResponse.statusCode == 201) {
             respuesta = ('Intake registrado correctamente tras redirección');
          } else {
            respuesta = ('Error al redirigir: ${newResponse.statusCode}');
          }
        }
      } else {
        respuesta = ('Error: ${response.statusCode}');
      }
    } catch (e) {
      respuesta = ('Error de conexión: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return respuesta;
  }


  Posology? getLoadedPosologyById(int posologyId){
    try {
      isLoading=true;
      final posology = posologies.firstWhere(
            (pos) => pos.id == posologyId,
      );
      isLoading=false;

      return posology;
    } catch (e) {
      isLoading=false;
      return null;
    }


  }

}
