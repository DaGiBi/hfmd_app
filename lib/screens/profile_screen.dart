import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = '';

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
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');

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
