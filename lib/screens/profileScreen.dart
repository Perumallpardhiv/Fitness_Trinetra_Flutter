import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinetraflutter/auth/auth.dart';
import 'package:trinetraflutter/auth/signin.dart';
import 'package:trinetraflutter/screens/editProfile.dart';
import 'package:trinetraflutter/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthClass auth = AuthClass();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Material(
              elevation: 10,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: ClipPath(
                clipper: Clip1Clipper(),
                child: Container(
                  height: 320,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userInfo')
                    .doc(user!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Loading ...");
                  }
                  var details = snapshot.data;
                  print(details);
                  print(details?['routine']);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 25,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 0,
                              bottom: 20,
                              right: 20,
                              left: 20,
                            ),
                            child: Text(
                              "PROFILE",
                              style: TextStyle(
                                fontSize: 35,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: 180,
                        height: 180,
                        decoration: const BoxDecoration(
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
                      const SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Hii ${details!['name'].toString().toUpperCase()}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.email),
                                const SizedBox(width: 10.0),
                                Text(
                                  details['email'],
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.calendar_month),
                                const SizedBox(width: 10.0),
                                const Text(
                                  "Joined On:",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  details['joinedAt'],
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () async {},
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Card(
                                      elevation: 7,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      child: const Center(
                                        child:
                                            Icon(Icons.person_search_outlined),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfile(),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Card(
                                      elevation: 7,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.edit),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    themeProvider.themeMode == ThemeMode.light
                                        ? themeProvider.toggleTheme(true)
                                        : themeProvider.toggleTheme(false);
                                  },
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Card(
                                      elevation: 7,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      child: Consumer<ThemeProvider>(
                                        builder: (context, value, child) {
                                          return Center(
                                            child: value.themeMode ==
                                                    ThemeMode.light
                                                ? Icon(Icons.light)
                                                : Icon(Icons.light_mode),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    Share.share(
                                      'Check out the Exercise app TRINETRA',
                                    );
                                  },
                                  child: SizedBox(
                                    height: 60,
                                    child: Card(
                                      elevation: 7,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Row(
                                          children: [
                                            Text("Share"),
                                            SizedBox(width: 10),
                                            Icon(Icons.share),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () async {
                                    auth.logOut();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignIn(),
                                      ),
                                      (route) => false,
                                    );
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('isLogged', false);
                                  },
                                  child: SizedBox(
                                    height: 60,
                                    child: Card(
                                      elevation: 7,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Row(
                                          children: [
                                            Text("Logout"),
                                            SizedBox(width: 10),
                                            Icon(Icons.logout),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Clip1Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();
    path.lineTo(0, h - h / 16);
    path.quadraticBezierTo(w / 32, h - h / 128, w / 10, h);
    path.lineTo(w - w / 10, h);
    path.quadraticBezierTo(w - w / 32, h - h / 128, w, h - h / 16);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
