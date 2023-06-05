import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    setState(() {
      _username = username ?? '';
    });
 // Fetch user data from MongoDB
    try {
      String url = 'http://192.168.0.110:5000/get-user/$_username';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _email = userData['email'];
          _phone = userData['phone'];
          _gender = userData['gender'];
        });
      } else {
        // Handle error response
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle request error
      print('Error fetching user data: $e');
    }
  }


  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Logged-in User: $_username'),
          Text('Email: $_email'),
          Text('Phone: $_phone'),
          Text('Gender: $_gender'),
          ElevatedButton(
            child: Text('Edit Profile'),
            onPressed: () {
              // Implement profile editing functionality
            },
          ),
          ElevatedButton(
            child: Text('Logout'),
            onPressed: _logout,
          ),
        ],
      ),
    );
  }
}
