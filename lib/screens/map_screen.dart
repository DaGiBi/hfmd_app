import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:hfmd_app/services/mongo_service.dart';
import 'package:hfmd_app/utilities/location_utils.dart';
import 'package:location/location.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:hfmd_app/screens/constant.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<HFMDMarker> markers = [];
  List<FacilitiesMarker> fcMarkers = [];
  MapController mapController = MapController();
  HFMDMarker? selectedMarker;
  FacilitiesMarker? selectedFcMarker;
  LocationData? _locationData;
  
  @override
  void initState() {
    super.initState();
    _loadSession();
    fetchDataHFMD();
    fetchDataFacilities();
  }
  Future<void> _loadSession() async {
    final locationData = await LocationUtilities.getDeviceLocation();
    setState(() {
      _locationData = locationData;
    });
  }
   Future<void> fetchDataHFMD() async {
    markers = await MongoServices.fetchHotspot();
    // print(markers);
    setState(() {});
  }

  void onMarkerTap(HFMDMarker marker) {
    setState(() {
      selectedMarker = marker;
    });
  }


  // facilites marker
  Future<void> fetchDataFacilities() async {
    fcMarkers = await MongoServices.fetchFacilities();
    // print(markers);
    setState(() {});
  }

  void onFCMarkerTap(FacilitiesMarker fcMarker) {
    setState(() {
      selectedFcMarker = fcMarker;
    });
  }

    void onMapTap(TapPosition position, LatLng latlng) {
    setState(() {
      selectedMarker = null;
      selectedFcMarker = null;
    });
  }

  // 3.0, locationData?.longitude ?? 101.6
  @override
  Widget build(BuildContext context) {
    final locationData = _locationData;
    if (locationData == null) {
      // Return a loading indicator or handle the null case
      return CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
              child: Text('Showing Recent Positive HFMD'),
            ),
            Flexible(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: LatLng(locationData.latitude ?? 3.0, locationData.longitude ?? 101.6),
                  zoom: 11,
                  maxBounds: LatLngBounds(
                    LatLng(-90, -180),
                    LatLng(90, 180),
                  ),
                  onTap: onMapTap,
                  onPositionChanged: (MapPosition position, bool hasGesture) {
                    if (hasGesture) {
                      setState(() {
                        selectedMarker = null;
                        selectedFcMarker = null;
                      });
                    }
                  }
                  
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
                        builder: (ctx) => GestureDetector(
                          onTap: () => onMarkerTap(marker),
                          child: Icon(Icons.place,color: Colors.red),
                        ),
                      );
                    }).toList(),
                  ),
                  MarkerLayer(
                    markers: fcMarkers.map((fcMarker) {
                      return Marker(
                        width: 20,
                        height: 20,
                        point: LatLng(fcMarker.latitude, fcMarker.longitude),
                        builder: (ctx) => GestureDetector(
                          onTap: () => onFCMarkerTap(fcMarker),
                          child: Icon(Icons.local_hospital,color: Colors.lightBlue),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // hfmd marker ... ignore: unnecessary_null_comparison
            if (selectedMarker != null) ...[
              const SizedBox(height: 8),
              Text("Diagnosed Information:\nDate: ${selectedMarker!.dateDiagnose}\nTime: ${selectedMarker!.timeDiagnose}"),
              
            ],

            // facilites marker .... ignore: unnecessary_null_comparison
            if (selectedFcMarker != null) ...[
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => LocationUtilities.openGoogleMaps(
                  selectedFcMarker!.latitude.toString(),
                  selectedFcMarker!.longitude.toString(),
                ),
                child: Text("Health Facilites Information:\nName: ${selectedFcMarker!.facilityName}"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

