import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Posology {
  Posology(this.id, this.hour, this.minute, this.medication_id);

  final int id;
  final int hour;
  final int minute;
  final int medication_id;
  bool starred = false;

  Posology.fromJson(Map<String, dynamic> json)
      : medication_id = json["medication_id"],
        id = json["id"],
        minute = json["minute"],
        hour = json["hour"],
        starred = false;

  @override
  String toString() {
    return "$id | $hour | $minute | $medication_id";
  }
}
