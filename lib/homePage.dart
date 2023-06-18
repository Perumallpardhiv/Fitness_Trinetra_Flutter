import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txt = TextEditingController();
  var userDetails = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: txt),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('userInfo')
                    .doc(userDetails!.uid)
                    .set(
                  {
                    'uid': userDetails!.uid,
                    'email': userDetails!.email,
                    'name': txt.text,
                  },
                );
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
