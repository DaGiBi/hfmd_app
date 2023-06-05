// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fl_chart/fl_chart.dart';

// class AnalyticScreen extends StatefulWidget {
//   @override
//   _AnalyticScreenState createState() => _AnalyticScreenState();
// }

// class _AnalyticScreenState extends State<AnalyticScreen> {
//   List<PredictionData> _predictionData = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchPredictionData();
//   }

//   Future<void> _fetchPredictionData() async {
//     final String url = 'your_flask_server_url/prediction_data';

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       final List<PredictionData> predictionData = data
//           .map<PredictionData>((item) => PredictionData.fromJson(item))
//           .toList();

//       setState(() {
//         _predictionData = predictionData;
//       });
//     } else {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Failed to fetch prediction data.'),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Analytics')),
//       body: _predictionData.isNotEmpty
//           ? BarChart(
//               BarChartData(
//                 titlesData: FlTitlesData(
//                   show: true,
//                   bottomTitles: SideTitles(
//                     showTitles: true,
//                     textStyle: TextStyle(color: Colors.black),
//                     margin: 10,
//                     getTitles: (double value) {
//                       final month = value.toInt();
//                       return _predictionData[month - 1].month;
//                     },
//                   ),
//                   leftTitles: SideTitles(
//                     showTitles: true,
//                     textStyle: TextStyle(color: Colors.black),
//                     margin: 10,
//                     getTitles: (double value) {
//                       if (value == 0) {
//                         return '0';
//                       } else if (value % 10 == 0) {
//                         return '${value.toInt()}%';
//                       } else {
//                         return '';
//                       }
//                     },
//                   ),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 barGroups: _predictionData
//                     .asMap()
//                     .entries
//                     .map(
//                       (entry) => BarChartGroupData(
//                         x: entry.key + 1,
//                         barRods: [
//                           BarChartRodData(
//                             y: entry.value.predictionPercentage,
//                             color: Colors.blue,
//                             width: 20,
//                           ),
//                         ],
//                       ),
//                     )
//                     .toList(),
//               ),
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }

// class PredictionData {
//   final String month;
//   final double predictionPercentage;

//   PredictionData({
//     required this.month,
//     required this.predictionPercentage,
//   });

//   factory PredictionData.fromJson(Map<String, dynamic> json) {
//     return PredictionData(
//       month: json['month'],
//       predictionPercentage: json['predictionPercentage'].toDouble(),
//     );
//   }
// }
