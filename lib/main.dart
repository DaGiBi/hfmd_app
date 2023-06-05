import 'package:flutter/material.dart';
import 'package:hfmd_app/screens/landing_screen.dart';
import 'package:hfmd_app/screens/login_screen.dart';
import 'package:hfmd_app/screens/register_screen.dart';
import 'package:hfmd_app/screens/bottom_bar.dart';
import 'package:hfmd_app/screens/home_screen.dart';
import 'package:hfmd_app/screens/upload_screen.dart';
import 'package:hfmd_app/screens/list_screen.dart';
import 'package:hfmd_app/screens/profile_screen.dart';
// import 'package:hfmd_app/screens/analytic_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Recognition App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/bottomBar': (context) => BottomBar(),
        '/home': (context) => HomeScreen(),
        '/upload': (context) => UploadScreen(),
        '/list': (context) => ListScreen(),
        '/profile': (context) => ProfileScreen(),
        // '/analytic': (context) => AnalyticScreen(),
      },
    );
  }
}
