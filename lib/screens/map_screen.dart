import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:hfmd_app/services/mongo_service.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:hfmd_app/screens/constant.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<MapMarker> markers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

   Future<void> fetchData() async {
    markers = await MongoServices.fetchHotspot();
    // print(markers);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
              child: Text('This is a map that is showing (51.5, -0.9).'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(3.0, 101.6),
                  zoom: 11,
                  maxBounds: LatLngBounds(
                    LatLng(-90, -180),
                    LatLng(90, 180),
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(
                    markers: markers.map((marker) {
                      return Marker(
                        width: 20,
                        height: 20,
                        point: LatLng(marker.latitude, marker.longitude),
                        builder: (ctx) => FlutterLogo(
                          textColor: Colors.blue,
                          key: ObjectKey(Colors.blue),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

