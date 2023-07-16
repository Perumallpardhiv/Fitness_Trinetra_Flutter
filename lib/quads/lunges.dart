import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinetraflutter/camera_view.dart';
import 'package:trinetraflutter/quads/pointer_lunges.dart';
import 'package:trinetraflutter/routine_value.dart';
import 'package:trinetraflutter/values.dart';

class Lunges extends StatefulWidget {
  const Lunges({super.key});

  @override
  State<Lunges> createState() => _LungesState();
}

class _LungesState extends State<Lunges> {
  PoseDetector poseDetector = GoogleMlKit.vision.poseDetector();
  bool isBusy = false;
  CustomPaint? customPaint;

  Future<void> storeCalories() async {
    print("Calories Counted");
    final prefs = await SharedPreferences.getInstance();
    var cal = (counter * 0.2).ceilToDouble();
    var userDetails = FirebaseAuth.instance.currentUser;

    if (prefs.getString('date') != null) {
      if (prefs.getString('date') ==
          "${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}") {
        var calories = prefs.getDouble('quads') ?? 0;
        routine[6] = routine[6] + cal;
        cal = calories + cal;
        prefs.setDouble('quads', cal);
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
        prefs.setDouble('quads', cal);
        double abs = prefs.getDouble('abs') ?? 0;
        double glutes = prefs.getDouble('glutes') ?? 0;
        double chest = prefs.getDouble('chest') ?? 0;
        double back = prefs.getDouble('back') ?? 0;
        prefs.setDouble('abs', abs);
        prefs.setDouble('glutes', glutes);
        prefs.setDouble('chest', chest);
        prefs.setDouble('back', back);

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
      prefs.setDouble('quads', cal);
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
    print("Counter: $counter \n Calories: $cal");
  }

  @override
  void initState() {
    ResetValue();
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
    return CameraView(
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
    const PoseLandmarkType leftpos1 = PoseLandmarkType.leftHip;
    const PoseLandmarkType leftpos2 = PoseLandmarkType.leftKnee;
    const PoseLandmarkType leftpos3 = PoseLandmarkType.leftAnkle;

    const PoseLandmarkType rightpos1 = PoseLandmarkType.rightHip;
    const PoseLandmarkType rightpos2 = PoseLandmarkType.rightKnee;
    const PoseLandmarkType rightpos3 = PoseLandmarkType.rightAnkle;

    // final faces = await faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePointer_Lunges(
          poses,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
          110,
          125,
          75,
          95,
          leftpos1,
          leftpos2,
          leftpos3,
          rightpos1,
          rightpos2,
          rightpos3);
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
