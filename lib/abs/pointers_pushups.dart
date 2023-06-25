import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:trinetraflutter/translator.dart';
import 'package:trinetraflutter/values.dart';

late Timer timetime;

class PosePainter_pushUp extends CustomPainter {
  final List<Pose> poses;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final int minangle;
  final int minangle2;
  final PoseLandmarkType leftpos1;
  final PoseLandmarkType leftpos2;
  final PoseLandmarkType leftpos3;
  final PoseLandmarkType rightpos1;
  final PoseLandmarkType rightpos2;
  final PoseLandmarkType rightpos3;

  PosePainter_pushUp(
    this.poses,
    this.absoluteImageSize,
    this.rotation,
    this.minangle,
    this.minangle2,
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
      ..color = Colors.yellow;

    for (var pose in poses) {
      final landmark = pose.landmarks[leftpos1]!; //shoulder
      final landmark2 = pose.landmarks[leftpos2]!; //hip
      final landmark5 = pose.landmarks[leftpos3]!; //ankle

      final landmark1 = pose.landmarks[rightpos1]!;
      final landmark3 = pose.landmarks[rightpos2]!;
      final landmark4 = pose.landmarks[rightpos3]!;

      angle = (atan2(landmark5.y - landmark.y, landmark5.x - landmark.x)) *
          180 ~/
          PI;

      angler = (atan2(landmark4.y - landmark1.y, landmark4.x - landmark1.x)) *
          180 ~/
          PI;

      if (angle < 0) {
        angle = angle * -1;
      }

      if (angler < 0) {
        angler = angler * -1;
      }
      print("Angle: $angle");
      print("Angler: $angler");
      if ((stage != "down" && angle > 20 && angle < 60) ||
          (stage != "down" && angler > 20 && angler < 60)) {
        stage = "down";
        color = Colors.green;
      }
      if (stage == "down") {
        color = Colors.green;
        align = true;
      } else {
        color = Colors.deepPurple;
        align = false;
      }
      if ((stage == "down" && angle >= 0 && angle < 10) ||
          (stage == "down" && angler >= 0 && angler < 10)) {
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
  bool shouldRepaint(covariant PosePainter_pushUp oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.poses != poses;
  }
}
