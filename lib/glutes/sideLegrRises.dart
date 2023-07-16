import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinetraflutter/camera_view.dart';
import 'package:trinetraflutter/glutes/posePointer_sideLegRises.dart';
import 'package:trinetraflutter/routine_value.dart';
import 'package:trinetraflutter/values.dart';

class SideLegRises extends StatefulWidget {
  const SideLegRises({super.key});

  @override
  State<SideLegRises> createState() => _SideLegRisesState();
}

class _SideLegRisesState extends State<SideLegRises> {
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
        var calories = prefs.getDouble('glutes') ?? 0;
        routine[6] = routine[6] + cal;
        cal = calories + cal;
        prefs.setDouble('glutes', cal);
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
        prefs.setDouble('glutes', cal);
        double abs = prefs.getDouble('abs') ?? 0;
        double quads = prefs.getDouble('quads') ?? 0;
        double chest = prefs.getDouble('chest') ?? 0;
        double back = prefs.getDouble('back') ?? 0;
        prefs.setDouble('abs', abs);
        prefs.setDouble('quads', quads);
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
      prefs.setDouble('glutes', cal);
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
    const PoseLandmarkType leftpos1 = PoseLandmarkType.leftShoulder;
    const PoseLandmarkType leftpos2 = PoseLandmarkType.leftHip;
    const PoseLandmarkType leftpos3 = PoseLandmarkType.leftAnkle;

    const PoseLandmarkType rightpos1 = PoseLandmarkType.rightShoulder;
    const PoseLandmarkType rightpos2 = PoseLandmarkType.rightHip;
    const PoseLandmarkType rightpos3 = PoseLandmarkType.rightAnkle;

    // final faces = await faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePointer_SideLegRises(
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
