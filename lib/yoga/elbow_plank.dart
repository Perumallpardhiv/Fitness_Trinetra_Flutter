import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinetraflutter/camera_view_timer.dart';
import 'package:trinetraflutter/routine_value.dart';
import 'package:trinetraflutter/values_timer.dart';
import 'package:trinetraflutter/yoga/pointer_elbow.dart';

class ElbowPlank extends StatefulWidget {
  const ElbowPlank({super.key});

  @override
  State<ElbowPlank> createState() => _ElbowPlankState();
}

class _ElbowPlankState extends State<ElbowPlank> {
  PoseDetector poseDetector = GoogleMlKit.vision.poseDetector();
  final PoseLandmarkType leftpos1 = PoseLandmarkType.leftShoulder;
  final PoseLandmarkType leftpos2 = PoseLandmarkType.leftElbow;
  final PoseLandmarkType leftpos3 = PoseLandmarkType.leftWrist;
  final PoseLandmarkType rightpos1 = PoseLandmarkType.rightShoulder;
  final PoseLandmarkType rightpos2 = PoseLandmarkType.rightElbow;
  final PoseLandmarkType rightpos3 = PoseLandmarkType.rightWrist;
  bool isBusy = false;
  CustomPaint? customPaint;

  Future<void> storeCalories() async {
    print("Calories Counted");
    final prefs = await SharedPreferences.getInstance();
    var cal = (timer * 0.25).ceilToDouble();
    var userDetails = FirebaseAuth.instance.currentUser;

    if (prefs.getString('date') != null) {
      if (prefs.getString('date') ==
          "${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}") {
        var calories = prefs.getDouble('back') ?? 0;
        routine[6] = routine[6] + cal;
        cal = calories + cal;
        prefs.setDouble('back', cal);
        await FirebaseFirestore.instance
            .collection('userInfo')
            .doc(userDetails!.uid)
            .update(
          {
            "routine": routine,
          },
        );
      } else {
        prefs.setString('date',
            "${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}");
        prefs.setDouble('back', cal);
        double abs = prefs.getDouble('abs') ?? 0;
        double quads = prefs.getDouble('quads') ?? 0;
        double glutes = prefs.getDouble('glutes') ?? 0;
        double chest = prefs.getDouble('chest') ?? 0;
        prefs.setDouble('abs', abs);
        prefs.setDouble('quads', quads);
        prefs.setDouble('glutes', glutes);
        prefs.setDouble('chest', chest);

        routine.removeAt(0);
        routine.add(cal);
        await FirebaseFirestore.instance
            .collection('userInfo')
            .doc(userDetails!.uid)
            .update(
          {
            "routine": routine,
          },
        );
      }
    } else {
      prefs.setString('date',
          "${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}");
      prefs.setDouble('back', cal);
      routine.removeAt(0);
      routine.add(cal);
      await FirebaseFirestore.instance
          .collection('userInfo')
          .doc(userDetails!.uid)
          .update(
        {
          "routine": routine,
        },
      );
    }
    print("Counter: $timer \n Calories: $cal");
  }

  @override
  void initState() {
    ResetTimerValue();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await storeCalories();
    await poseDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return CameraViewTimer(
      customPaint: customPaint,
      onImage: (inputImage) {
        processImage(inputImage);
      },
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final poses = await poseDetector.processImage(inputImage);

    // final faces = await faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter_elbowPlank(
        poses,
        inputImage.inputImageData!.size,
        inputImage.inputImageData!.imageRotation,
        85,
        105,
        leftpos1,
        leftpos2,
        leftpos3,
        rightpos1,
        rightpos2,
        rightpos3,
      );
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
