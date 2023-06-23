import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hfmd_app/widgets/data_point.dart';

class ChartAge extends StatelessWidget {
  final List<dynamic> ageData;

  ChartAge(this.ageData);

  List<DataPoint> processData() {
    final agePredictionCountsHFMD = <String, int>{};
    final agePredictionCountsNotHFMD = <String, int>{};
    final ageGroups = <String>[];

    for (final entry in ageData) {
      final age = entry['age'] as String;
      final prediction = entry['prediction'] as String;
      final ageGroup = getAgeGroup(age);

      if (prediction == 'HFMD') {
        agePredictionCountsHFMD[ageGroup] = (agePredictionCountsHFMD[ageGroup] ?? 0) + 1;
      } else if (prediction == 'Not-HFMD') {
        agePredictionCountsNotHFMD[ageGroup] = (agePredictionCountsNotHFMD[ageGroup] ?? 0) + 1;
      }

      if (!ageGroups.contains(ageGroup)) {
        ageGroups.add(ageGroup);
      }
    }

    ageGroups.sort((a, b) {
      final startAgeA = int.parse(a.split('-').first.trim());
      final startAgeB = int.parse(b.split('-').first.trim());
      return startAgeA.compareTo(startAgeB);
    });

    final ageDataPointsHFMD = ageGroups
        .map((ageGroup) => DataPoint(ageGroup, agePredictionCountsHFMD[ageGroup] ?? 0))
        .toList();

    final ageDataPointsNotHFMD = ageGroups
        .map((ageGroup) => DataPoint(ageGroup, agePredictionCountsNotHFMD[ageGroup] ?? 0))
        .toList();

    return [...ageDataPointsHFMD, ...ageDataPointsNotHFMD];
  }

  String getAgeGroup(String age) {
    final ageValue = int.tryParse(age);
    if (ageValue != null) {
      final startAge = ((ageValue ~/ 10) * 10).toString();
      final endAge = ((ageValue ~/ 10) * 10 + 9).toString();
      return '$startAge - $endAge';
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final dataPoints = processData();
    final theme = Theme.of(context);
    return Container(
      height: 200,
      child: SfCartesianChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.top,
          textStyle: theme.textTheme.bodyText1,
          iconBorderColor: theme.primaryColor,
        ),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        series: <ChartSeries>[
          StackedLineSeries<DataPoint, String>(
            dataSource: dataPoints,
            xValueMapper: (DataPoint dataPoint, _) => dataPoint.category,
            yValueMapper: (DataPoint dataPoint, _) => dataPoint.value,
            name: 'HFMD',
            color: theme.colorScheme.secondary,
          ),
          StackedLineSeries<DataPoint, String>(
            dataSource: dataPoints,
            xValueMapper: (DataPoint dataPoint, _) => dataPoint.category,
            yValueMapper: (DataPoint dataPoint, _) => dataPoint.value,
            name: 'Not-HFMD',
            color: theme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}
