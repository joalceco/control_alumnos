import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Matriculas{
  final List<dynamic> alumnos;

  Matriculas({this.alumnos});

  factory Matriculas.fromJson(Map<String,dynamic> json){
    return Matriculas(
      alumnos: json["alumnos"],
    );
  }
}

Future<Matriculas> fetchMatriculas() async{
  final response = await http.get("http://bde878335cad.ngrok.io/api/alumnos");
  if(response.statusCode == 200){
    return Matriculas.fromJson(json.decode(response.body));
  }else{
    throw Exception("No se encontraron las matriculas");
  }

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Future<Matriculas> futureMatriculas;

  @override
  void initState() {
    super.initState();
    futureMatriculas = fetchMatriculas();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }


  List<Widget> display_matriculas(Matriculas matriculas){
    List<Widget> list = [];
    for (var alumno in matriculas.alumnos)
      list.add(
        Card(child: Container(child: Row(
          children: [
            Expanded(
                child: Container(
              child:Text(alumno["matricula"]),
              width: 200,
            ),
            flex: 1,
            ),
            Expanded(
                child: Text(alumno["nombre"]),
                    flex: 3,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
            padding: EdgeInsets.all(16),
        ),
        )

      );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:
          FutureBuilder<Matriculas>(
          future: futureMatriculas,
          builder: (context, snapshot){
            if(snapshot.hasData){
              var alumnos = display_matriculas(snapshot.data);
              return ListView(children: alumnos,);
            }else if(snapshot.hasError){
              return Text("Error");
            }
            return CircularProgressIndicator();
          }
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
