import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class LocationUtilities {
  static Future<LocationData?> getDeviceLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    final _locationData = await location.getLocation();
    return _locationData;
  }

  static Future<Map<String, dynamic>> getCityState(LocationData location) async{
    final latitude = location.latitude;
    final longitude = location.longitude;
    final apiUrl = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=10&format=json&limit=1';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonData;
      } else {
        print('Failed to fetch location data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching location data: $e');
    }
    return {};
  }

  static void openGoogleMaps(String latitude, String longitude) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
