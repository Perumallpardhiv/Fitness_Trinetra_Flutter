import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinetraflutter/abs/pointer_flutterkicks.dart';
import 'package:trinetraflutter/camera_view.dart';
import 'package:trinetraflutter/values.dart';

class FlutterKicks extends StatefulWidget {
  const FlutterKicks({super.key});

  @override
  State<FlutterKicks> createState() => _FlutterKicksState();
}

class _FlutterKicksState extends State<FlutterKicks> {
  PoseDetector poseDetector = GoogleMlKit.vision.poseDetector();
  bool isBusy = false;
  CustomPaint? customPaint;

  Future<void> storeCalories() async {
    print("Calories Counted");
    final prefs = await SharedPreferences.getInstance();
    var cal = (counter * 0.2).ceilToDouble();

    if(prefs.getString('date') != null){
      if(prefs.getString('date') == "${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}"){
        var calories = prefs.getDouble('abs') ?? 0;
        cal = calories + cal;
        prefs.setDouble('abs', cal);
      } else {
        prefs.setString('date',"${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}");
        prefs.setDouble('abs', cal);
        double quads = prefs.getDouble('quads') ?? 0;
        double glutes = prefs.getDouble('glutes') ?? 0;
        double chest = prefs.getDouble('chest') ?? 0;
        double back = prefs.getDouble('back') ?? 0;
        prefs.setDouble('quads', quads);
        prefs.setDouble('glutes', glutes);
        prefs.setDouble('chest', chest);
        prefs.setDouble('back', back);
      }
    } else {
      prefs.setString('date',"${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}");
      prefs.setDouble('abs', cal);
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
      final painter = PosePainter_flutterKicks(
        poses,
        inputImage.inputImageData!.size,
        inputImage.inputImageData!.imageRotation,
        45,
        65,
        45,
        65,
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
