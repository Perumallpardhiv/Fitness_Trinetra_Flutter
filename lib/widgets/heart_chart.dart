import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class ChartComp extends StatelessWidget {
  final List<SensorValue> allData;
  const ChartComp({Key? key, required this.allData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      [
        charts.Series<SensorValue, DateTime>(
          id: 'Values',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (SensorValue values, _) => values.time,
          measureFn: (SensorValue values, _) => values.value,
          data: allData,
        )
      ],
      animate: false,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          zeroBound: false,
        ),
      ),
      behaviors: [
        charts.ChartTitle(
          'Time',
          behaviorPosition: charts.BehaviorPosition.bottom,
          titleStyleSpec: const charts.TextStyleSpec(fontSize: 14),
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        ),
        charts.ChartTitle(
          'Beat',
          behaviorPosition: charts.BehaviorPosition.start,
          titleStyleSpec: const charts.TextStyleSpec(fontSize: 14),
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        )
      ],
      domainAxis: const charts.DateTimeAxisSpec(),
    );
  }
}

class SensorValue {
  final DateTime time;
  final double value;

  SensorValue(this.time, this.value);
}
