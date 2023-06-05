import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hfmd_app/screens/home_screen.dart';
import 'package:hfmd_app/screens/login_screen.dart';


class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _isLoading = true;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _checkInternetConnectivity() async {
    bool isConnected = await checkInternetConnectivity();
    setState(() {
      _isConnected = isConnected;
      _isLoading = false;
    });
    if (isConnected) {
      // Connected to the internet, navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isConnected ? 'Checking internet connection...' : 'No internet connection',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  if (!_isConnected)
                    ElevatedButton(
                      onPressed: _navigateToHomeScreen,
                      child: Text('Go to Home Screen'),
                    ),
                ],
              ),
      ),
    );
  }
}
