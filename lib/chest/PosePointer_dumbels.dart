import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:trinetraflutter/translator.dart';
import 'package:trinetraflutter/values.dart';

class PosePainter_dumbels extends CustomPainter {
  final List<Pose> poses;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final int minangle;
  final int minangle2;
  final int maxangle;
  final int maxangle2;
  final PoseLandmarkType leftpos1;
  final PoseLandmarkType leftpos2;
  final PoseLandmarkType leftpos3;
  final PoseLandmarkType rightpos1;
  final PoseLandmarkType rightpos2;
  final PoseLandmarkType rightpos3;

  PosePainter_dumbels(
    this.poses,
    this.absoluteImageSize,
    this.rotation,
    this.minangle,
    this.minangle2,
    this.maxangle,
    this.maxangle2,
    this.leftpos1,
    this.leftpos2,
    this.leftpos3,
    this.rightpos1,
    this.rightpos2,
    this.rightpos3,
  );

  @override
  void paint(Canvas canvas, Size size) {
    const double PI = 3.141592653589793238;
    Color color;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    final dot = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0
      ..color = Color.fromRGBO(255, 235, 59, 1);

    for (var pose in poses) {
      final landmark = pose.landmarks[leftpos1]!; // left shoulder
      final landmark2 = pose.landmarks[leftpos2]!; // left elbow
      final landmark5 = pose.landmarks[leftpos3]!; // left wrist

      final landmark1 = pose.landmarks[rightpos1]!; // rightShoulder
      final landmark3 = pose.landmarks[rightpos2]!; // rightElbow
      final landmark4 = pose.landmarks[rightpos3]!; // rightWrist

      angle = (atan2(landmark5.y - landmark2.y, landmark5.x - landmark2.x) -
              atan2(landmark.y - landmark2.y, landmark.x - landmark2.x)) *
          180 ~/
          PI;
      angle1 = (atan2(landmark5.y - landmark2.y, landmark5.x - landmark2.x) -
              atan2(landmark.y - landmark2.y, landmark.x - landmark2.x)) *
          180 ~/
          PI;

      if (angle < 0) {
        angle = angle + 360;
      }
      // if (angle > 180) {
      //   angle = 360 - angle;
      // }
      if (angle1 < 0) {
        angle1 = angle1 + 360;
      }
      // if (angle1 > 180) {
      //   angle1 = 360 - angle1;
      // }
      print("Angle: $angle");
      print("Angle1: $angle1");
      if ((angle > 50 && angle < 70 && stage != "down") &&
          (angle1 > 50 && angle1 < 70 && stage != "down")) {
        stage = "down";
        color = Colors.green;
      }
      if (stage == "down") {
        color = Colors.green;
        align = true;
      } else {
        color = Colors.red;
        align = false;
      }
      if ((angle > 120 && angle < 140 && stage == "down") &&
          (angle1 > 120 && angle1 < 140 && stage == "down")) {
        counter++;
        stage = "up";
      }

      canvas.drawCircle(
        Offset(
          translateX(landmark.x, rotation, size, absoluteImageSize),
          translateY(landmark.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(landmark1.x, rotation, size, absoluteImageSize),
          translateY(landmark1.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(landmark2.x, rotation, size, absoluteImageSize),
          translateY(landmark2.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(landmark3.x, rotation, size, absoluteImageSize),
          translateY(landmark3.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(landmark4.x, rotation, size, absoluteImageSize),
          translateY(landmark4.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(landmark5.x, rotation, size, absoluteImageSize),
          translateY(landmark5.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        PoseLandmark joint1 = pose.landmarks[type1]!;
        PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
          Offset(translateX(joint1.x, rotation, size, absoluteImageSize),
              translateY(joint1.y, rotation, size, absoluteImageSize)),
          Offset(translateX(joint2.x, rotation, size, absoluteImageSize),
              translateY(joint2.y, rotation, size, absoluteImageSize)),
          paintType,
        );
      }

      //Draw arms
      paintLine(leftpos1, leftpos2, paint..color = color);
      paintLine(leftpos2, leftpos3, paint);
      paintLine(rightpos1, rightpos2, paint..color = color);
      paintLine(rightpos2, rightpos3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter_dumbels oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.poses != poses;
  }
}
