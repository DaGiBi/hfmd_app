import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isConnected = false;


  @override
  void initState() {
    super.initState();
    _loadSession();
  }
  
  Future<void> _loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isConnected = prefs.getBool('isConnected');
    setState(() {
      _isConnected = isConnected!;
    });
  }
  List<BottomNavigationBarItem> getBottomNavItems() {
    List<BottomNavigationBarItem> items = [
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
    ];

    // Add condition to show/hide Analytics item
    if (_isConnected) {
      // items.add(
      //   BottomNavigationBarItem(
      //     icon: Icon(Icons.analytics),
      //     label: 'Analytics',
      //   ),
      // );
      items.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      );
  }

    return items;
  }

  List<Widget> getWidgetOptions() {
    List<Widget> options = [
      HomeScreen(),
      UploadScreen(),
      ListScreen(),
      
    ];

    // Add condition to include Profile screen
    if (_isConnected) {
      options.add(ProfileScreen());
    }

    return options;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = getWidgetOptions(); // Use the updated method to get options

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: getBottomNavItems(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
