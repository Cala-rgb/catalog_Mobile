class Elev {
  int? id;
  late String name, clasa;
  Elev(this.id, this.name, this.clasa);
  Elev.withoutId(this.name, this.clasa);
  Elev.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    name = m["name"];
    clasa = m["clasa"];
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["clasa"] = clasa;
    return map;
  }
}