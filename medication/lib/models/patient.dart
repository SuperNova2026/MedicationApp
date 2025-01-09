
class Patient {
  Patient(this.id, this.code, this.name, this.surname);

  final int id;
  final String code;
  final String name;
  final String surname;
  bool starred = false;

  Patient.fromJson(Map<String, dynamic> json)
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
