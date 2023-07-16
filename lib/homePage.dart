import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trinetraflutter/main.dart';
import 'package:trinetraflutter/routine_value.dart';
import 'package:trinetraflutter/screens/dailyStreak.dart';
import 'package:trinetraflutter/screens/gym.dart';
import 'package:trinetraflutter/screens/heartBeat.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userDetails = FirebaseAuth.instance.currentUser;
  var index = 1;
  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  final items = <Widget>[
    const Icon(Icons.stacked_bar_chart_outlined),
    const Icon(Icons.fitness_center),
    const Icon(Icons.sports_gymnastics_outlined),
    const Icon(Icons.monitor_heart_outlined),
  ];

  final screens = [
    const DailyStreak(),
    const Gym(),
    Container(),
    HeartBeat(cameras: cameras!),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userInfo')
            .doc(userDetails!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Loading..."));
          }
          var details = snapshot.data;
          print(details!['routine']);
          List<dynamic> cal = details['routine'];
          routine.clear();
          for (var element in cal) {
            double ele = element.toDouble();
            routine.add(ele);
          }
          return screens[index];
        },
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        child: CurvedNavigationBar(
          key: navigationKey,
          color: Theme.of(context).colorScheme.tertiary,
          buttonBackgroundColor: Theme.of(context).colorScheme.tertiary,
          items: items,
          height: 60,
          backgroundColor: Colors.transparent,
          index: index,
          onTap: (index) {
            setState(() {
              this.index = index;
            });
          },
        ),
      ),
    );
  }
}
