import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinetraflutter/camera_view.dart';
import 'package:trinetraflutter/chest/PosePointer_dumbels.dart';
import 'package:trinetraflutter/values.dart';

class dumbells extends StatefulWidget {
  const dumbells({Key? key}) : super(key: key);

  @override
  _dumbellsState createState() => _dumbellsState();
}

class _dumbellsState extends State<dumbells> {
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
    calculate();
  }

  Future<void> calculate() async {
    final prefs = await SharedPreferences.getInstance();
    var calories = prefs.getInt('chest') ?? 0;
    var cal = calories + (counter * 0.02).toInt();
    prefs.setInt('chest', cal);
    print("Calories Counted:${cal}");
  }

  @override
  void initState() {
    ResetValue();
    super.initState();
  }

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
    // final faces = await faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter_dumbels(
        poses,
        inputImage.inputImageData!.size,
        inputImage.inputImageData!.imageRotation,
        50,
        70,
        120,
        140,
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
