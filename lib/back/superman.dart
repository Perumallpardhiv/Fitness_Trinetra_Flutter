import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinetraflutter/back/posePointer_superman.dart';
import 'package:trinetraflutter/camera_view.dart';
import 'package:trinetraflutter/values.dart';

class Superman extends StatefulWidget {
  const Superman({super.key});

  @override
  State<Superman> createState() => _SupermanState();
}

class _SupermanState extends State<Superman> {
  PoseDetector poseDetector = GoogleMlKit.vision.poseDetector();
  bool isBusy = false;
  CustomPaint? customPaint;

  Future<void> storeCalories() async {
    print("Calories Counted");
    final prefs = await SharedPreferences.getInstance();
    var calories = prefs.getInt('back') ?? 0;
    var cal = calories + (counter * 0.3).toInt();
    prefs.setInt('back', cal);
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
    const PoseLandmarkType pos1 = PoseLandmarkType.rightWrist;
    const PoseLandmarkType pos2 = PoseLandmarkType.rightHip;
    const PoseLandmarkType pos3 = PoseLandmarkType.rightKnee;

    // final faces = await faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePointer_Superman(
            poses,
            inputImage.inputImageData!.size,
            inputImage.inputImageData!.imageRotation,
            110,
            125,
            75,
            95,
            pos1,
            pos2,
            pos3,
          ),
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
