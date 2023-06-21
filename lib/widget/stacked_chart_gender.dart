import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackedColumnChart extends StatelessWidget {
  final List<dynamic> genderData;

  StackedColumnChart(this.genderData);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SfCartesianChart(
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        series: <ChartSeries>[
          StackedColumnSeries<_ChartData, String>(
            dataSource: getChartData(genderData, 'Male'),
            xValueMapper: (_ChartData data, _) => data.prediction,
            yValueMapper: (_ChartData data, _) => data.count,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.middle,
              labelPosition: ChartDataLabelPosition.inside,
            ),
            color: Color.fromRGBO(29, 130, 139, 1), // Male - HFMD
            name: 'Male',
          ),
          StackedColumnSeries<_ChartData, String>(
            dataSource: getChartData(genderData, 'Female'),
            xValueMapper: (_ChartData data, _) => data.prediction,
            yValueMapper: (_ChartData data, _) => data.count,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.middle,
              labelPosition: ChartDataLabelPosition.inside,
            ),
            color: Color.fromRGBO(238, 64, 53, 1), // Female - HFMD
            name: 'Female',
          ),
        ],
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
      ),
    );
  }

  List<_ChartData> getChartData(List<dynamic> genderData, String gender) {
    final hfmdCount = genderData
        .where((data) => data['gender'] == gender && data['prediction'] == 'HFMD')
        .length;
    final notHfmdCount = genderData
        .where((data) => data['gender'] == gender && data['prediction'] == 'NOT-HFMD')
        .length;

    return [
      _ChartData('HFMD', hfmdCount),
      _ChartData('NOT-HFMD', notHfmdCount),
    ];
  }
}

class _ChartData {
  final String prediction;
  final int count;

  _ChartData(this.prediction, this.count);
}
