import 'package:database_management_system_project/Register_Screen.dart';
import 'package:database_management_system_project/User%20Pages/User_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import '../Database_connection/Mysql.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _message = '';

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      Results results = await conn.query(
        'SELECT * FROM Author WHERE AUTHOR_NAME = ? AND AUTHOR_PASSWORD = ?',
        [username, password],
      );

      if (results.isNotEmpty) {
        // Başarılı giriş
        setState(() {
          _message = 'Login successful!';
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Builder(builder: (_) => UserScreen(username: username, password: password),
                )
            ),
            ModalRoute.withName('/'));
      } else {
        // Hatalı giriş
        setState(() {
          _message = 'Username or password is wrong!';
        });
      }
    } catch (e) {
      print('Hata: $e');
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'User Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('login'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Builder(builder: (_) => RegisterScreen(),
                          )
                      ),
                      );
                },
                child: Text("register")),

            Text(
              _message,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}