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
}

class Absenta {
  int? id;
  late String data;
  Absenta(this.id, this.data);
  Absenta.withoutId(this.data);
  Absenta.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    data = m["data"];
  }
}

class Nota {
  int? id;
  late String data;
  late int nota;
  Nota(this.id, this.data, this.nota);
  Nota.withoutId(this.data, this.nota);
  Nota.fromMap(Map<String, dynamic> m) {
    id = m["id"];
    data = m["data"];
    nota = m["nota"];
  }
}