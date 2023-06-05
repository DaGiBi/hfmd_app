import 'package:flutter/material.dart';
import 'package:hfmd_app/screens/upload_screen.dart';
import 'package:hfmd_app/screens/list_screen.dart';
import 'package:hfmd_app/screens/profile_screen.dart';
import 'package:hfmd_app/screens/home_screen.dart';
// import 'package:hfmd_app/screens/analytic_screen.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    UploadScreen(),
    ListScreen(),
    ProfileScreen(),
    // AnalyticScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
                icon: Icon(Icons.upload),
                label: 'Home',
              ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.analytics),
      //       label: 'Analytics',
      //     ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
