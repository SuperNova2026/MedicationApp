class Posology {
  Posology(this.id, this.hour, this.minute, this.medicationId);

  final int id;
  final int hour;
  final int minute;
  final int medicationId;
  bool starred = false;

  Posology.fromJson(Map<String, dynamic> json)
      : medicationId = json["medication_id"],
        id = json["id"],
        minute = json["minute"],
        hour = json["hour"],
        starred = false;

  @override
  String toString() {
    return "$id | $hour | $minute | $medicationId";
  }
}
