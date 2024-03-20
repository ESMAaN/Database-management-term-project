import 'package:database_management_system_project/User%20Pages/Login_screen.dart';
import 'package:database_management_system_project/Search_screen.dart';
import 'package:database_management_system_project/Theses_detailed_screen.dart';
import 'package:database_management_system_project/models/Thesis_card_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database Project',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Database Project'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Builder(builder: (_) => SearchScreen(),
                          )
                      ),
                      ModalRoute.withName('/'));
                },
                child: Text("search ")),
            Container(
              height: 15,
            ),

            ElevatedButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Builder(builder: (_) => LoginScreen(),
                          )
                      ),
                      ModalRoute.withName('/'));
                },
                child: Text("Login or Register")),


          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
