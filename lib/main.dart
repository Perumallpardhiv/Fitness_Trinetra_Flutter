import 'package:camera/camera.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinetraflutter/introScreens/splash.dart';
import 'package:trinetraflutter/theme_data.dart';
import 'package:trinetraflutter/theme_provider.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences shares = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  cameras = await availableCameras();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(
              theme: shares.getString('themeMode') ?? "ThemeMode.light",
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          // ignore: deprecated_member_use
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          themeMode: value.themeMode,
          theme: MyThemes().lightTheme,
          darkTheme: MyThemes().darkTheme,
          home: const Splash(),
        );
      },
    );
  }
}
