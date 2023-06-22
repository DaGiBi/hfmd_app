import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:hfmd_app/services/mongo_constant.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo;
// import 'package:hfmd_app/services/mongo_service.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = '';
  String _email = '';
  String _phone = '';
  String _gender = '';

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final String? phone = prefs.getString('phone');
    final String? email = prefs.getString('email');
    final String? gender = prefs.getString('gender');
    

    setState(() {
      _username = username ?? '';
      _phone = phone ?? '';
      _email = email ?? '';
      _gender = gender ?? '';
    });
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.remove('username');

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logged-in User: $_username',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            Text(
              'Email: $_email',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 8),
            Text(
              'Phone: $_phone',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 8),
            Text(
              'Gender: $_gender',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text(
                'Edit Profile',
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                // Implement profile editing functionality
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text(
                'Logout',
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: _logout,
            ),
          ],
        ),
      ),
    );
  }
}