import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hfmd_app/widgets/data_point.dart';

class ChartCity extends StatelessWidget {
  final List<DataPoint> dataPoints;

  const ChartCity({required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SfCircularChart(
        legend: Legend(isVisible: true),
        series: <DoughnutSeries<DataPoint, String>>[
          DoughnutSeries<DataPoint, String>(
            dataSource: dataPoints,
            xValueMapper: (DataPoint dataPoint, _) => dataPoint.category,
            yValueMapper: (DataPoint dataPoint, _) => dataPoint.value,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
            ),
          ),
        ],
      ),
    );
  }
}
