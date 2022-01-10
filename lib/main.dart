import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
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

class Page2 extends StatefulWidget {
  const Page2({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {

  void maCar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const MyHomePage(title: "Clase"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: BackButton(
          color: Colors.blue,
          onPressed: maCar,
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {

  Future<int> addElevi() async {
    Elev firstElev = Elev(name: "elev1", clasa: "XI MI1");
    Elev secondElev = Elev(name: "elev2", clasa: "XI MI1");
    List<Elev> listOfElevi = [firstElev, secondElev];
    return await this.handler.insertElev(listOfElevi);
  }


  int _counter = 0;

  late DB_Handler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DB_Handler();
    this.handler.initializeDatabase().whenComplete(() async {
      await this.addElevi();
      setState(() {});
    });
  }

/*
  void facAlteChestii() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const Page2(title: "E bine daca am ajuns aici"),
      ),
    );
  }
*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: this.handler.retrieveUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<Elev>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await this.handler.deleteElev(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(snapshot.data![index].clasa),
                      )),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
