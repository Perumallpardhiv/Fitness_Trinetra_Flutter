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
    final prefs = await SharedPreferences.getInstance();
    var cal = (counter * 0.2).ceilToDouble();

    if(prefs.getString('date') != null){
      if(prefs.getString('date') == "${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}"){
        var calories = prefs.getDouble('chest') ?? 0;
        cal = calories + cal;
        prefs.setDouble('chest', cal);
      } else {
        prefs.setDouble('chest', cal);
      }
    } else {
      prefs.setDouble('chest', cal);
    }
    print("Counter: $counter \n Calories: $cal");
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
