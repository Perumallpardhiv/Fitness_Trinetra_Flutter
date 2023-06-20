import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinetraflutter/camera_view.dart';
import 'package:trinetraflutter/values.dart';

import 'pointer_elbow.dart';

class ElbowPlank extends StatefulWidget {
  const ElbowPlank({super.key});

  @override
  State<ElbowPlank> createState() => _ElbowPlankState();
}

class _ElbowPlankState extends State<ElbowPlank> {
  PoseDetector poseDetector = GoogleMlKit.vision.poseDetector();
  bool isBusy = false;
  CustomPaint? customPaint;

  Future<void> storeCalories() async {
    print("Calories Counted");
    final prefs = await SharedPreferences.getInstance();
    var calories = prefs.getInt('abs') ?? 0;
    var cal = calories + (counter * 0.15).toInt();
    prefs.setInt('abs', cal);
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
    const PoseLandmarkType leftpos2 = PoseLandmarkType.leftElbow;
    const PoseLandmarkType leftpos3 = PoseLandmarkType.leftWrist;

    const PoseLandmarkType rightpos1 = PoseLandmarkType.rightShoulder;
    const PoseLandmarkType rightpos2 = PoseLandmarkType.rightElbow;
    const PoseLandmarkType rightpos3 = PoseLandmarkType.rightWrist;

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
