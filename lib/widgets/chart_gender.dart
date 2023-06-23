import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartGender extends StatelessWidget {
  final List<dynamic> genderData;

  ChartGender(this.genderData);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 200,
      child: SfCartesianChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: theme.textTheme.bodyText1,
          iconBorderColor: theme.primaryColor,
        ),
        series: <ChartSeries>[
          StackedColumnSeries<_ChartData, String>(
            dataSource: getChartData(genderData, 'Male'),
            xValueMapper: (_ChartData data, _) => data.prediction,
            yValueMapper: (_ChartData data, _) => data.count,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.middle,
              labelPosition: ChartDataLabelPosition.inside,
              textStyle: theme.textTheme.bodyText2!.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            color: theme.colorScheme.secondary,
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
              textStyle: theme.textTheme.bodyText2!.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            color: theme.colorScheme.tertiary,
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
