class Elev {
  final int? id;
  final String name;
  final String clasa;
  Elev({
    this.id,
    required this.name,
    required this.clasa
    });
  //TODO: Sa-mi dau seama de ce e doua puncte aici ca ma depaseste =))
  Elev.fromMap(Map<String, dynamic> res) :
      id = res["id"],
      name = res["name"],
      clasa = res["clasa"];

  Map<String, Object?> toMap() {
    return {'id':id,'name': name, 'clasa': clasa};
  }
}