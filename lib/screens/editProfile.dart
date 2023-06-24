import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = "";
  String descr = "";
  String age = "";

  @override
  Widget build(BuildContext context) {
    var userDetails = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('userInfo')
                      .doc(userDetails!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("Loading ...");
                    }
                    var details = snapshot.data;
                    name = name == "" ? details!['name'] : name;
                    descr = descr == "" ? details!['description'] : descr;
                    age = age == "" ? details!['age'] : age;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "EDIT PROFILE",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 18),
                        Center(
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                "assets/images/male.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 35.0),
                              child: TextFormField(
                                initialValue: details!['name'],
                                onChanged: ((value) {
                                  setState(() {
                                    name = value;
                                  });
                                }),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                obscureText: false,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 3),
                                  labelText: "User Name",
                                  labelStyle: TextStyle(fontSize: 16),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 35.0),
                              child: TextFormField(
                                initialValue: details['description'],
                                onChanged: ((value) {
                                  setState(() {
                                    descr = value;
                                  });
                                }),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                obscureText: false,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 3),
                                  labelText: "Description",
                                  labelStyle: TextStyle(fontSize: 16),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 35.0),
                              child: TextFormField(
                                initialValue: details['age'].toString(),
                                onChanged: ((value) {
                                  setState(() {
                                    age = value;
                                  });
                                }),
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                obscureText: false,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 3),
                                  labelText: "Age",
                                  labelStyle: TextStyle(fontSize: 16),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "CANCEL",
                                style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 2.2,
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                try {
                                  Navigator.pop(context);
                                  await FirebaseFirestore.instance
                                      .collection('userInfo')
                                      .doc(userDetails.uid)
                                      .update(
                                    {
                                      'name': name.trim(),
                                      'description': descr.trim(),
                                      'age': age,
                                    },
                                  );
                                } catch (e) {
                                  print(e);
                                }
                              },
                              color: Theme.of(context).colorScheme.primary,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "UPDATE",
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 2.2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
