import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:hfmd_app/services/mongo_service.dart';
import 'package:hfmd_app/widgets/chart_age.dart';
import 'package:hfmd_app/widgets/data_point.dart';
import '../widgets/chart_city.dart';
import '../widgets/chart_gender.dart';
import '../widgets/chart_month.dart';

class AnalyticScreen extends StatefulWidget {
  @override
  _AnalyticScreenState createState() => _AnalyticScreenState();
}

class _AnalyticScreenState extends State<AnalyticScreen> {
  List<DataPoint> cityDataPoints = [];
  List<dynamic> ageData = [];
  List<dynamic> genderData = [];
  List<dynamic> monthData = [];
  bool _isLoading = false;
  CancelableOperation? _fetchDataOperation;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      _fetchDataOperation = CancelableOperation.fromFuture(
        MongoServices.fetchAnalyticData(),
      );

      final jsonData = await _fetchDataOperation!.value;
      final cityPredictionCounts = <String, int>{};

      for (final entry in jsonData!) {
        final city = entry['location']['city'] as String;
        final DateTime date = DateTime.parse(entry['dateDiagnose']);
        final int year = date.year;

        if (year != selectedYear) {
          continue;
        }

        cityPredictionCounts[city] = (cityPredictionCounts[city] ?? 0) + 1;
      }

      if (mounted) {
        setState(() {
          cityDataPoints = cityPredictionCounts.entries
              .map((entry) => DataPoint(entry.key, entry.value))
              .toList();

          ageData = jsonData
              .where((entry) {
                final DateTime date = DateTime.parse(entry['dateDiagnose']);
                return date.year == selectedYear;
              })
              .toList();
          genderData = jsonData
              .where((entry) {
                final DateTime date = DateTime.parse(entry['dateDiagnose']);
                return date.year == selectedYear;
              })
              .toList();
          monthData = jsonData
              .where((entry) {
                final DateTime date = DateTime.parse(entry['dateDiagnose']);
                return date.year == selectedYear;
              })
              .toList();
        });
      }
    } catch (e) {
      throw Exception('Failed to fetch data');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void updateSelectedYear(int? year) {
  if (year != null) {
    setState(() {
      selectedYear = year;
    });
    fetchData();
  }
}


  @override
  void dispose() {
    _fetchDataOperation?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final years = List<int>.generate(10, (index) => DateTime.now().year - index);
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Visualization'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                SizedBox(height: 10),
                DropdownButton<int>(
                  value: selectedYear,
                  onChanged: updateSelectedYear,
                  items: years.map((int year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                ),
                Text(
                  'Location (City) vs Prediction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ChartCity(dataPoints: cityDataPoints),
                SizedBox(height: 20),
                Text(
                  'Date of Diagnose (Month) vs Prediction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ChartMonth(monthData),
                SizedBox(height: 20),
                Text(
                  'Age Group vs Prediction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ChartAge(ageData),
                Text(
                  'Gender vs HFMD and Not-HFMD Prediction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ChartGender(genderData),
                
              ],
            ),
    );
  }
}
