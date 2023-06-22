import 'package:flutter/material.dart';
// import 'package:hfmd_app/screens/constant.dart';
import 'package:hfmd_app/screens/register_screen.dart';
import 'package:hfmd_app/services/mongo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _Bypass() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', "najib");
    await prefs.setString('email', "najib@mail");
    await prefs.setString('phone', "01911092");
    await prefs.setString('gender', "male");
    Navigator.pushReplacementNamed(context, '/bottomBar');
  }
  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final loginService = MongoServices();
    final loginResult = await loginService.login(username, password);

    if (loginResult == LoginResult.success) {
      // Login successful, save session and navigate to the home screen
      final mongoService = MongoServices();
      final userData = await mongoService.getUserProfile(username);

      if (userData != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('email', userData['email']);
        await prefs.setString('phone', userData['phone']);
        await prefs.setString('gender', userData['gender']);
      }

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

  void _navigateToRegisterScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
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
              onPressed: _login,
            ),
            ElevatedButton(
              child: Text('Registers'),
              onPressed: _navigateToRegisterScreen,
            ),
            ElevatedButton(
              child: Text('Bypass'),
              onPressed: _Bypass,
            ),
          ],
        ),
      ),
    );
  }
}
