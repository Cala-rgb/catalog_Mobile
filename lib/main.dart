import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';
import 'dbhandler.dart';
import 'objects.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catalog',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Clase'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late DB_Handler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DB_Handler();
    this.handler.initializeDatabase().whenComplete(() async {
      setState(() {});
    });
  }


   void goToClasa(String titlu) {
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(
         builder: (BuildContext context) => Clasa(title: titlu),
       ),
     );
   }

  void goToAddClasa() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AddClasa(title: "Adauga o clasa"),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: this.handler.getClase(),
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return TextButton(
                    style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {goToClasa(snapshot.data![index]);},
                  child: Text(snapshot.data![index]),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {goToAddClasa();},
      ),
    );
  }
}

class Clasa extends StatefulWidget {
  const Clasa({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<Clasa> createState() => _Clasa();
}

class _Clasa extends State<Clasa> {

  void goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MyHomePage(title: "Clase"),
      ),
    );
  }

  void goToAddElev() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AddElev(title: "Adauga un elev", clasa: widget.title),
      ),
    );
  }

  void goToPrezenta() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Prezenta(title: "Prezenta", clasa: widget.title),
      ),
    );
  }

  void goToSeeElev(int index, String name) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SeeElev(title: name, clasa: widget.title, index: index),
      ),
    );
  }

  late DB_Handler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DB_Handler();
    this.handler.initializeDatabase().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget> [
          Container(
              child: Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () {
                      goToAddElev();
                    },
                    child: Text("Adauga"),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () {
                      goToPrezenta();
                    },
                    child: Text("Prezenta"),
                  ),
                ],
              )
          ),
          Expanded (
            child: FutureBuilder(
              future: this.handler.getElevi(widget.title),
              builder: (BuildContext context, AsyncSnapshot<List<Elev>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {goToSeeElev(snapshot.data![index].id!, snapshot.data![index].name);},
                        child: Text(snapshot.data![index].name),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.green,
        onPressed: () {goBack();},
      ),
    );
  }
}

class AddClasa extends StatefulWidget {
  const AddClasa({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<AddClasa> createState() => _AddClasa();
}

class _AddClasa extends State<AddClasa> {

  void goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MyHomePage(title: "Clase"),
      ),
    );
  }

  late DB_Handler handler;
  int _clasa = 12;
  String _profil = "MI1";
  List<int> clase = [5, 6, 7, 8, 9, 10, 11, 12];
  var profiluri = ['MI1', 'MI2', 'SN1', 'SN2', 'SS', 'F', 'A', 'B'];
  @override
  void initState() {
    super.initState();
    this.handler = DB_Handler();
    this.handler.initializeDatabase().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row (
        children: <Widget>[
          Container(
          padding: EdgeInsets.all(20),
          child: DropdownButton(
              value: _clasa,
              items: clase.map((int items) {
                return DropdownMenuItem(
                  value: items,
                   child: Text(items.toString()),
               );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _clasa = newValue!;
                });
              }
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: DropdownButton(
                value: _profil,
                items: profiluri.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _profil = newValue!;
                  });
                }
            ),
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
               ),
            onPressed: () {
                handler.insertClasa(_clasa, _profil);
                goBack();
            },
            child: const Text("Adauga"),
          ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.green,
        onPressed: () {goBack();},
      ),
    );
  }
}

class AddElev extends StatefulWidget {
  const AddElev({Key? key, required this.title, required this.clasa}) : super(key: key);
  final String title;
  final String clasa;
  @override
  State<AddElev> createState() => _AddElev();
}

class _AddElev extends State<AddElev> {

  String _nume = "nume", _prenume = "prenume";

  void goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Clasa(title: widget.clasa),
      ),
    );
  }

  late DB_Handler handler;
  @override
  void initState() {
    super.initState();
    this.handler = DB_Handler();
    this.handler.initializeDatabase().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column (
        children: <Widget>[
          Row (
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nume',
                  ),
                    onChanged: (value) {
                    _nume = value;
                  }
                )
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                     border: OutlineInputBorder(),
                     labelText: 'Prenume',
                  ),
                  onChanged: (value) {
                    _prenume = value;
                  }
                )
             ),
         ]),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            onPressed: () {
              handler.insertElev(_nume + " " + _prenume, widget.clasa);
              goBack();
            },
            child: Text("Adauga"),
          ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.green,
        onPressed: () {goBack();},
      ),
    );
  }
}

class Prezenta extends StatefulWidget {
  const Prezenta({Key? key, required this.title, required this.clasa}) : super(key: key);
  final String title;
  final String clasa;
  @override
  State<Prezenta> createState() => _Prezenta();
}

class _Prezenta extends State<Prezenta> {

  List<bool> checkboxValues = List.filled(35, true);
  List<int> refrences = List.filled(35, -1);
  late DB_Handler handler;

  void goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Clasa(title: widget.clasa),
      ),
    );
  }

  void noteazaAbsente() {
    var now = DateTime.now();
    String data = now.day.toString() + "/" + now.month.toString() + "/" + now.year.toString();
    for (int i = 0; i < checkboxValues.length; ++i) {
      if (checkboxValues[i] == false) {
        handler.insertAbsenta(refrences[i], data);
      }
    }
    goBack();
  }

  @override
  void initState() {
    super.initState();
    this.handler = DB_Handler();
    this.handler.initializeDatabase().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget> [
          Container(
            child: Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {noteazaAbsente();},
              child: Text("Gata"),
              ),
            ],
          )
        ),
        Expanded(
          child: FutureBuilder(
            future: this.handler.getElevi(widget.clasa),
            builder: (BuildContext context, AsyncSnapshot<List<Elev>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    refrences[index] = snapshot.data![index].id!;
                    return Row(
                      children: <Widget>[
                        Text(snapshot.data![index].name),
                        Checkbox(
                         checkColor: Colors.white,
                         activeColor: Colors.green,
                         value: checkboxValues[index],
                         onChanged: (bool? value) {
                           setState(() {
                             checkboxValues[index] = value!;
                           });
                         },
                       ),
                    ]);
                  },
                );
              }
              else {
                  return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.green,
        onPressed: () {goBack();},
      ),
    );
  }
}

class SeeElev extends StatefulWidget {
  const SeeElev({Key? key, required this.title, required this.clasa, required this.index}) : super(key: key);
  final String title;
  final String clasa;
  final int index;
  @override
  State<SeeElev> createState() => _SeeElev();
}

class _SeeElev extends State<SeeElev> {

  late DB_Handler handler;

  void goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Clasa(title: widget.clasa),
      ),
    );
  }

  void stergeElev(int id) {
    handler.deleteElev(id);
    goBack();
  }

  void stergeNota(int id) {
    handler.deleteNota(id);
    setState(() {});
  }

  void stergeAbsenta(int id) {
    handler.deleteAbsenta(id);
    setState(() {});
  }

  //TODO: Sa fixez chestia asta
  void adaugaNota(int id) {
    var now = DateTime.now();
    String data = now.day.toString() + "/" + now.month.toString() + "/" + now.year.toString();
    showDialog(
        context: context, barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title:const Text('Adauga nota'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  handler.insertNota(id, 1, data);
                  setState(() {});
                },
                child:const Text('1'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  handler.insertNota(id, 2, data);
                  setState(() {});
                },
                child:const Text('2'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  handler.insertNota(id, 3, data);
                  setState(() {});
                },
                child:const Text('3'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  handler.insertNota(id, 4, data);
                  setState(() {});
                },
                child:const Text('4'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  handler.insertNota(id, 5, data);
                  setState(() {});
                },
                child:const Text('5'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  handler.insertNota(id, 6, data);
                  setState(() {});
                },
                child:const Text('6'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  handler.insertNota(id, 7, data);
                  setState(() {});
                },
                child:const Text('7'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  handler.insertNota(id, 8, data);
                  setState(() {});
                },
                child:const Text('8'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  handler.insertNota(id, 9, data);
                  setState(() {});
                },
                child:const Text('9'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  handler.insertNota(id, 10, data);
                  setState(() {});
                },
                child:const Text('10'),
              ),
            ]
          );
        },
    );
  }

  @override
  void initState() {
    super.initState();
    this.handler = DB_Handler();
    this.handler.initializeDatabase().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
          children: <Widget> [
            Container(
                child: Row (
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                          "Absente: ",
                          style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic)
                      ),
                    ])
            ),
            Container(
              child: FutureBuilder(
                future: this.handler.getAbsente(widget.index),
                builder: (BuildContext context, AsyncSnapshot<List<Absenta>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                            children: <Widget>[
                              Text(snapshot.data![index].data),
                              IconButton(
                                icon: Icon(Icons.delete_forever),
                                onPressed: () {stergeAbsenta(snapshot.data![index].id!);},
                              ),
                        ]);
                      },
                    );
                  }
                  else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Container(
                child: Row (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        onPressed: () {adaugaNota(widget.index);},
                        child: Text("Adauga nota"),
                      ),
                    ])
            ),
            Container(
                child: Row (
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Note: ",
                         style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic))
                    ])
            ),
            Container(
              child: FutureBuilder(
                future: this.handler.getNote(widget.index),
                builder: (BuildContext context, AsyncSnapshot<List<Nota>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                            children: <Widget>[
                              Text(snapshot.data![index].nota.toString() + " in " + snapshot.data![index].data),
                              IconButton(
                                icon: Icon(Icons.delete_forever),
                                onPressed: () {stergeNota(snapshot.data![index].id!);},
                              ),
                            ]);
                      },
                    );
                  }
                  else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Container(
                child: Row (
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        onPressed: () {stergeElev(widget.index);},
                        child: Text("Sterge elev"),
                      ),
                    ])
            ),
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.green,
        onPressed: () {goBack();},
      ),
    );
  }
}