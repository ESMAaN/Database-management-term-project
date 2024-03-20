import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'Database_connection/Mysql.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _registerUsernameController = TextEditingController();
  TextEditingController _registerPasswordController = TextEditingController();
  String _registerMessage = '';

  void _register() async {
    String username = _registerUsernameController.text;
    String password = _registerPasswordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _registerMessage = 'Username and password are required!';
      });
      return;
    }

    if (password.length > 15) {
      setState(() {
        _registerMessage = 'Password must be at most 15 characters!';
      });
      return;
    }

    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      await conn.query(
        'INSERT INTO Author (AUTHOR_NAME, AUTHOR_PASSWORD) VALUES (?, ?)',
        [username, password],
      );

      // Başarılı kayıt
      setState(() {
        _registerMessage = 'New author created!';
      });
    } catch (e) {
      print('Hata: $e');
      // Hatalı kayıt
      setState(() {
        _registerMessage = 'Could not create new author!';
      });
    } finally {
      await conn.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Kayıt Formu
            TextField(
              controller: _registerUsernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _registerPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _register,
              child: Text('Create new Author'),
            ),
            SizedBox(height: 8),
            Text(
              _registerMessage,
              style: TextStyle(
                color: _registerMessage.contains('New author created') ? Colors.green : Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
