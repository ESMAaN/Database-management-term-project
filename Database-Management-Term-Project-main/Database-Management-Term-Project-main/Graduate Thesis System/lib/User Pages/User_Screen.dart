import 'package:database_management_system_project/User%20Pages/User_Create_Theses_Screen.dart';
import 'package:database_management_system_project/User%20Pages/User_theses.dart';
import 'package:database_management_system_project/main.dart';
import 'package:flutter/material.dart';

import '../Search_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.username, required this.password});
  final String username;
  final String password;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında ne yapılacağını belirtin.
        return false; // false döndürerek geri tuşunu devre dışı bırakabilirsiniz.
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("User Screen"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Builder(builder: (_) => UserThesesPage(username: widget.username, password: widget.password),
                            )
                        ),
                        ModalRoute.withName('/'));
                  },
                  child: Text("Manage Your Theses")),

              ElevatedButton(
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Builder(builder: (_) => CreateTheses(username: widget.username, password: widget.password),
                            )
                        ),
                        ModalRoute.withName('/'));
                  },
                  child: Text("Create New Theses")),

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
                  child: Text("Go to search page")),

              ElevatedButton(
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Builder(builder: (_) => MyHomePage(title: "Database Project"),
                            )
                        ),
                        ModalRoute.withName('/'));
                  },
                  child: Text("Log out")),


            ],
          ),
        ),
      ),
    );
  }
}
