// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class MapWidget extends StatelessWidget {
//   final double latitude = 3.0711017;
//   final double longitude = 101.4837367;
//   final String city = "Shah Alam";

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final screenHeight = constraints.maxHeight;
//         final screenWidth = constraints.maxWidth;
//         final mapHeight = screenHeight * 0.8; // Adjust the height as needed

//         return Container(
//           height: mapHeight,
//           child: FlutterMap(
//             options: MapOptions(
//               center: LatLng(latitude, longitude),
//               zoom: 9.2,
//             ),
//             layers: [
//               TileLayerOptions(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 userAgent: 'com.example.app',
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
