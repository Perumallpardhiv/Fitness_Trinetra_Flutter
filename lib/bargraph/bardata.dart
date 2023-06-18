import 'package:trinetraflutter/bargraph/individual_bar.dart';

class BarData {
  final double day1;
  final double day2;
  final double day3;
  final double day4;
  final double day5;
  final double day6;
  final double day7;

  BarData({
    required this.day1,
    required this.day2,
    required this.day3,
    required this.day4,
    required this.day5,
    required this.day6,
    required this.day7,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: day1),
      IndividualBar(x: 1, y: day2),
      IndividualBar(x: 2, y: day3),
      IndividualBar(x: 3, y: day4),
      IndividualBar(x: 4, y: day5),
      IndividualBar(x: 5, y: day6),
      IndividualBar(x: 6, y: day7),
    ];
  }
}
