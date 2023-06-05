import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // for easy debug login
  Future<void> _login_pass() async {
    final String username = "najib";
      // Login successful, save session and navigate to the home screen
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      Navigator.pushReplacementNamed(context, '/bottomBar');
  } 

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final String url = 'http://192.168.0.110:5000/login';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Login successful, save session and navigate to the home screen
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      Navigator.pushReplacementNamed(context, '/bottomBar');
    } else {
      // Login failed, display an error message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Login Error'),
          content: Text('Invalid username or password.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: _login_pass,
            ),
          ],
        ),
      ),
    );
  }
}
