import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Homessss')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Logged-in User: dadadad'),
          ElevatedButton(
            child: Text('Edit Profile'),
            onPressed: () {
              // Implement profile editing functionality
            },
          ),
          
        ],
      ),
    );
  }
}
