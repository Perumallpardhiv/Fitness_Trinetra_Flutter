import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trinetraflutter/auth/auth.dart';
import 'package:trinetraflutter/auth/signin.dart';
import 'package:trinetraflutter/introScreens/page1.dart';
import 'package:trinetraflutter/introScreens/page2.dart';
import 'package:trinetraflutter/introScreens/page3.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  AuthClass authClass = AuthClass();
  final PageController _controller = PageController();
  bool onLastPage = false;
  bool onFirstPage = true;
  bool isLogged = false;

  Future<void> isLog() async {
    SharedPreferences shares = await SharedPreferences.getInstance();
    bool logg = shares.getBool('isLogged') ?? false;
    logg ? isLogged = true : isLogged = false;

    final prefs = await SharedPreferences.getInstance();
    print(prefs.getKeys());
  }

  @override
  void initState() {
    super.initState();
    isLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                onLastPage = value == 2 ? true : false;
                onFirstPage = value == 0 ? true : false;
              });
            },
            children: const [
              Page1(),
              Page2(),
              Page3(),
            ],
          ),
          Container(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, right: 20),
              child: TextButton(
                onPressed: () {
                  _controller.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                  );
                },
                child: const Text(
                  "SKIP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: const Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: !onFirstPage
                      ? const Text(
                          "BACK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text(
                          "     ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: SwapEffect(
                    dotColor: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    onLastPage
                        ? null
                        : _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                  },
                  child: onLastPage
                      ? !isLogged
                          ? Row(
                              children: [
                                RawMaterialButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignIn(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  fillColor: Theme.of(context).colorScheme.primary,
                                  focusColor: Theme.of(context).colorScheme.primary,
                                  shape: const StadiumBorder(),
                                  elevation: 0,
                                  child: const Text(
                                    "SIGN IN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    SharedPreferences shares =
                                        await SharedPreferences.getInstance();

                                    var email = shares.getString('email');
                                    var pwd = shares.getString('pwd');

                                    // ignore: use_build_context_synchronously
                                    await authClass.emailSignIn(
                                      context,
                                      email.toString(),
                                      pwd.toString(),
                                    );
                                  },
                                  child: const Text(
                                    "NEXT",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 17,
                                )
                              ],
                            )
                      : const Row(
                          children: [
                            Text(
                              "NEXT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 17,
                            )
                          ],
                        ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
