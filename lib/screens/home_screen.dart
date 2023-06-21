import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final bool? isConnected = prefs.getBool('isConnected');
    setState(() {
      _username = username ?? '';
      _isConnected = isConnected ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Homepage')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logged-in User: $_username',
              style: Theme.of(context).textTheme.headline6,
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
            Text(
              'Mode: ${_isConnected ? 'Connected' : 'Disconnected'}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
