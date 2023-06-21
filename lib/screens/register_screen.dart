import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hfmd_app/screens/constant.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  Future<bool> _validateUsername(String username) async {
    const url = '$constantUrl/validate-username';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['valid'];
    }

    return false;
  }
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final String username = _usernameController.text;
      final String password = _passwordController.text;
      final String email = _emailController.text;
      final String phone = _phoneController.text;
      final String gender = _genderController.text;
      
      final bool isUsernameValid = await _validateUsername(username);
      if (!isUsernameValid) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Invalid Username'),
            content: Text('The username is already taken or invalid.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        return;
      }
      const String url = '$constantUrl/register-user';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
          'phone': phone,
          'gender': gender,
        }),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Registration Success'),
            content: Text('Username: $username has been registered.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushReplacementNamed(context, '/login'); // Navigate to the login screen
                },
              ),
            ],
          ),
        );
      } else {
        // Registration failed, display an error message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Registration Error'),
            content: Text('Failed to register user. ${response.statusCode}'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Set the form key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  // You can add email validation logic here if needed
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  // You can add phone number validation logic here if needed
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _register();
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
