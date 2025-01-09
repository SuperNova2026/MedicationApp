class Medication {
  Medication(this.id, this.name, this.dosage, this.startDate, this.treatmentDuration, this.patientId);

  final int id;
  final String name;
  final double dosage;
  final String startDate;
  final int treatmentDuration;
  final int patientId;

  // Método para convertir un JSON en una instancia de Medication
  Medication.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        dosage = json["dosage"],
        startDate = json["start_date"],
        treatmentDuration = json["treatment_duration"],
        patientId = json["patient_id"];

  @override
  String toString() {
    return "ID: $id, Name: $name, Dosage: $dosage, Start Date: $startDate, Duration: $treatmentDuration months";
  }
}


