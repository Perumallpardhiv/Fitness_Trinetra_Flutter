import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).colorScheme.background,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              "Scan your body, unlock your potential",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "font2",
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Text(
              "Take care of your body. It's the only place you have to live",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Center(
            child: Lottie.asset(
              'assets/lottie/scan.json',
              fit: BoxFit.cover,
              height: size.height * 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
