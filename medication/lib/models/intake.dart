class Intake {
  Intake(this.id, this.date, this.medicationId);

  final int id;
  final int medicationId;
  final String date;
  bool starred = false;

  // Método para convertir un JSON en una instancia de Medication
  Intake.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        medicationId = json["medication_id"],
        date = json["date"],
        starred = false;
        
  @override
  String toString() {
    return "$id | $medicationId | $date";
  }
}
