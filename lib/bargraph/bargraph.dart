import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trinetraflutter/bargraph/bardata.dart';

class BarGraph extends StatelessWidget {
  final List weeklySummary;
  const BarGraph({
    super.key,
    required this.weeklySummary,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      day1: weeklySummary[0],
      day2: weeklySummary[1],
      day3: weeklySummary[2],
      day4: weeklySummary[3],
      day5: weeklySummary[4],
      day6: weeklySummary[5],
      day7: weeklySummary[6],
    );
    myBarData.initializeBarData();
    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitle),
          ),
        ),
        barGroups: myBarData.barData
            .map(
              (e) => BarChartGroupData(
                x: e.x,
                barRods: [
                  BarChartRodData(
                    toY: e.y,
                    color: Colors.deepPurple,
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 100,
                      color: Colors.deepPurple.shade50,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget getTitle(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('S', style: style);
        break;
      case 1:
        text = const Text('M', style: style);
        break;
      case 2:
        text = const Text('T', style: style);
        break;
      case 3:
        text = const Text('W', style: style);
        break;
      case 4:
        text = const Text('T', style: style);
        break;
      case 5:
        text = const Text('F', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text("", style: style);
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
