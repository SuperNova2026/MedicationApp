class Medication {
  Medication(this.id, this.name, this.dosage, this.startDate, this.treatmentDuration, this.patientId);

  final int id;
  final String startDate;
  final int patientId;
  final String name;
  final double dosage;
  final int treatmentDuration;

  // Método para convertir un JSON en una instancia de Medication
  Medication.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        startDate = json["start_date"],
        patientId = json["patient_id"],
        name = json["name"],
        dosage = json["dosage"].toDouble(),
        treatmentDuration = json["treatment_duration"];

  @override
  String toString() {
    return "$id | $name | $dosage | $startDate |$treatmentDuration";
  }
}


