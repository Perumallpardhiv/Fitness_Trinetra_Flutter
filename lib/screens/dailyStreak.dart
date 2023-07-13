import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinetraflutter/bargraph/bargraph.dart';
import 'package:trinetraflutter/screens/profileScreen.dart';
import 'package:trinetraflutter/theme_provider.dart';

class DailyStreak extends StatefulWidget {
  const DailyStreak({super.key});

  @override
  State<DailyStreak> createState() => _DailyStreakState();
}

class _DailyStreakState extends State<DailyStreak> {
  final userDetails = FirebaseAuth.instance.currentUser;
  late SharedPreferences prefs;
  late double abs = 0;
  late double quads = 0;
  late double glutes = 0;
  late double chest = 0;
  late double back = 0;

  Map<String, double> dataMap = {
    "Abs": 0,
    "Quads": 0,
    "Glutes": 0,
    "Chest": 0,
    "Back": 0,
  };

  @override
  void initState() {
    super.initState();
    preference();
  }

  preference() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('date') != null) {
      if (prefs.getString('date') ==
          "${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}") {
        abs = prefs.getDouble('abs') ?? 0;
        quads = prefs.getDouble('quads') ?? 0;
        glutes = prefs.getDouble('glutes') ?? 0;
        chest = prefs.getDouble('chest') ?? 0;
        back = prefs.getDouble('back') ?? 0;
      } else {
        abs = 0;
        quads = 0;
        glutes = 0;
        chest = 0;
        back = 0;
      }
    } else {
      abs = prefs.getDouble('abs') ?? 0;
      quads = prefs.getDouble('quads') ?? 0;
      glutes = prefs.getDouble('glutes') ?? 0;
      chest = prefs.getDouble('chest') ?? 0;
      back = prefs.getDouble('back') ?? 0;
    }
    dataMap = {
      "Abs": abs,
      "Quads": quads,
      "Glutes": glutes,
      "Chest": chest,
      "Back": back,
    };
    setState(() {});
  }

  List<dynamic> cal = [];
  List<double> cal2 = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBody: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userInfo')
                    .doc(userDetails!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text("Loading ..."));
                  }
                  var details = snapshot.data;
                  var name = details!['name'] ?? "John";
                  cal = details['routine'];
                  cal2.clear();
                  for (var element in cal) {
                    double ele = element.toDouble();
                    cal2.add(ele);
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text("Hi, $name"),
                          subtitle: const Text("Let's check your activity"),
                          trailing: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/images/male.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25,
                          left: 25,
                          right: 25,
                          bottom: 30,
                        ),
                        child: SizedBox(
                          height: 220,
                          child: BarGraph(weeklySummary: cal2),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Divider(thickness: 1.5),
                      ),
                      Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: value.themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "Today's Data",
                                      style: TextStyle(
                                        color: value.themeMode == ThemeMode.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Consumer<ThemeProvider>(
                        builder: (BuildContext context, value, Widget? child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 100,
                              top: 25,
                              left: 15,
                              right: 15,
                            ),
                            child: Center(
                              child: PieChart(
                                dataMap: dataMap,
                                chartLegendSpacing: 30,
                                chartType: ChartType.disc,
                                centerText: "CALORIES",
                                centerTextStyle: TextStyle(
                                  fontSize: 14,
                                  color: value.themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.grey.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                                totalValue: abs + chest + glutes + back + quads,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 1.8,
                                legendOptions: const LegendOptions(
                                  legendPosition: LegendPosition.right,
                                  legendShape: BoxShape.circle,
                                  showLegendsInRow: false,
                                  showLegends: true,
                                ),
                                legendLabels: {
                                  "Abs": "Abs - ${abs.toInt()} Cal",
                                  "Quads": "Quads - ${quads.toInt()} Cal",
                                  "Glutes": "Glutes - ${glutes.toInt()} Cal",
                                  "Chest": "Chest - ${chest.toInt()} Cal",
                                  "Back": "Back - ${back.toInt()} Cal",
                                },
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValuesInPercentage: false,
                                  showChartValues: true,
                                  chartValueStyle: TextStyle(
                                    color: value.themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                  decimalPlaces: 0,
                                  showChartValuesOutside: false,
                                  chartValueBackgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
