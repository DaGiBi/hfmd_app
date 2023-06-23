import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartMonth extends StatelessWidget {
  final List<dynamic> monthData;

  const ChartMonth(this.monthData);

  @override
  Widget build(BuildContext context) {
    final List<DataPointMonth> dataPoints = processData(monthData);
    final theme = Theme.of(context);
    return Container(
      height: 200,
      child: SfCartesianChart(
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        series: <StackedColumnSeries<DataPointMonth, String>>[
          StackedColumnSeries<DataPointMonth, String>(
            dataSource: dataPoints,
            xValueMapper: (DataPointMonth dataPoint, _) => dataPoint.category,
            yValueMapper: (DataPointMonth dataPoint, _) => dataPoint.value1,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.middle,
              labelPosition: ChartDataLabelPosition.inside,
            ),
            name: 'HFMD',
            color: theme.colorScheme.primary,
          ),
          StackedColumnSeries<DataPointMonth, String>(
            dataSource: dataPoints,
            xValueMapper: (DataPointMonth dataPoint, _) => dataPoint.category,
            yValueMapper: (DataPointMonth dataPoint, _) => dataPoint.value2,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.middle,
              labelPosition: ChartDataLabelPosition.inside,
            ),
            name: 'NOT-HFMD',
            color: theme.colorScheme.tertiary,
          ),
        ],
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
      ),
    );
  }

  List<DataPointMonth> processData(List<dynamic> monthData) {
    final Map<String, List<dynamic>> dataByMonth = {};

    // Group data by month
    for (final data in monthData) {
      final DateTime date = DateTime.parse(data['dateDiagnose']);
      final String month = '${date.year}-${date.month}';

      if (!dataByMonth.containsKey(month)) {
        dataByMonth[month] = [];
      }

      dataByMonth[month]!.add(data);
    }

    // Calculate count for HFMD and NOT-HFMD predictions for each month
    final List<DataPointMonth> dataPoints = [];
    dataByMonth.forEach((month, data) {
      final int hfmdCount = data.where((d) => d['prediction'] == 'HFMD').length;
      final int notHfmdCount =
          data.where((d) => d['prediction'] == 'NOT-HFMD').length;

      dataPoints.add(DataPointMonth(month, hfmdCount, notHfmdCount));
    });

    return dataPoints;
  }
}

class DataPointMonth {
  final String category;
  final int value1;
  final int value2;

  DataPointMonth(this.category, this.value1, this.value2);
}
