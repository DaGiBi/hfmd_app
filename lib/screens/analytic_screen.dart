import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hfmd_app/screens/constant.dart';
import 'package:hfmd_app/widget/stacked_chart_gender.dart';

class AnalyticScreen extends StatefulWidget {
  @override
  _AnalyticScreenState createState() => _AnalyticScreenState();
}

class _AnalyticScreenState extends State<AnalyticScreen> {

  List<DataPoint> cityDataPoints = [];
  List<DataPoint> monthDataPoints = [];
  List<DataPoint> ageDataPoints = [];
    List<dynamic> genderData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = '$constantUrl/analytics';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;

      final cityPredictionCounts = <String, int>{};
      final monthPredictionCounts = <String, int>{};
      final agePredictionCounts = <String, int>{};


      for (final entry in jsonData) {
        final city = entry['location']['city'] as String;
        final month = entry['dateDiagnose'].split('-')[1];
        final age = entry['age'] as String;


        cityPredictionCounts[city] = (cityPredictionCounts[city] ?? 0) + 1;
        monthPredictionCounts[month] = (monthPredictionCounts[month] ?? 0) + 1;
        agePredictionCounts[age] = (agePredictionCounts[age] ?? 0) + 1;
      }

      setState(() {
        cityDataPoints = cityPredictionCounts.entries
            .map((entry) => DataPoint(entry.key, entry.value))
            .toList();

        monthDataPoints = monthPredictionCounts.entries
            .map((entry) => DataPoint(entry.key, entry.value))
            .toList();

        ageDataPoints = agePredictionCounts.entries
            .map((entry) => DataPoint(entry.key, entry.value))
            .toList();
        genderData = jsonData;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Visualization'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Location (City) vs Prediction',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildChart(cityDataPoints),
          SizedBox(height: 20),
          Text(
            'Date of Diagnose (Month) vs Prediction',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildChart(monthDataPoints),
          SizedBox(height: 20),
          Text(
            'Age Group vs Prediction',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildChart(ageDataPoints),
        Text(
          'Gender vs HFMD and Not-HFMD Prediction',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildStackedChart(genderData),
        ],
      ),
    );
  }

  Widget _buildChart(List<DataPoint> dataPoints) {
    return Container(
      height: 200,
      child: SfCartesianChart(
        series: <StackedColumnSeries<DataPoint, String>>[
          StackedColumnSeries<DataPoint, String>(
            dataSource: dataPoints,
            xValueMapper: (DataPoint dataPoint, _) => dataPoint.category,
            yValueMapper: (DataPoint dataPoint, _) => dataPoint.value,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.middle,
              labelPosition: ChartDataLabelPosition.inside,
            ),
          ),
        ],
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
      ),
    );
  }
  Widget _buildStackedChart(List<dynamic> genderData) {
    return Container(
      height: 300,
      child: StackedColumnChart(genderData),
    );
}
}

class DataPoint {
  final String category;
  final int value;

  DataPoint(this.category, this.value);
}

class _ChartData {
  final String gender;
  final int count;
  final String prediction;

  _ChartData(this.gender, this.count, this.prediction);
}