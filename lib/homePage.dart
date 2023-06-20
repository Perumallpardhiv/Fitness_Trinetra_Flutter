import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trinetraflutter/screens/dailyStreak.dart';
import 'package:trinetraflutter/screens/gym.dart';

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
  ];

  final screens = [
    const DailyStreak(),
    const Gym(),
    Container(),
    // const Yoga(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[index],
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
