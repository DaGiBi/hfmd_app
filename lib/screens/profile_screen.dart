import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hfmd_app/screens/constant.dart';

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
      String url = '$constantUrl/get-user/$_username';
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
    await prefs.remove("username");

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
