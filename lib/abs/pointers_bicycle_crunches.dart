import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:trinetraflutter/translator.dart';
import 'package:trinetraflutter/values.dart';

class PosePainter_bicycleCrunches extends CustomPainter {
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

  PosePainter_bicycleCrunches(
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
      ..color = Colors.yellow;

    for (var pose in poses) {
      final left1 = pose.landmarks[leftpos1]!; //hip
      final left2 = pose.landmarks[leftpos2]!; //knee
      final left3 = pose.landmarks[leftpos3]!; //ankle

      final right1 = pose.landmarks[rightpos1]!; //hip
      final right2 = pose.landmarks[rightpos2]!; //knee
      final right3 = pose.landmarks[rightpos3]!; //ankle

      angle = (atan2(left3.y - left2.y, left3.x - left2.x) -
              atan2(left1.y - left2.y, left1.x - left2.x)) *
          180 ~/
          PI;

      angle1 = (atan2(right3.y - right2.y, right3.x - right2.x) -
              atan2(right1.y - right2.y, right1.x - right2.x)) *
          180 ~/
          PI;
      // print("Angle1: $angle1");

      // angle = (atan2(left3.y - left1.y, left3.x - left1.x)) *
      //     180 ~/
      //     PI; //left leg straight

      // angle1 = (atan2(right3.y - right2.y, right3.x - right2.x) -
      //         atan2(right1.y - right2.y, right1.x - right2.x)) *
      //     180 ~/
      //     PI; // right leg curve

      // angler = (atan2(right3.y - right1.y, right3.x - right1.x)) *
      //     180 ~/
      //     PI; //right leg straight

      // angle1r = (atan2(left3.y - left2.y, left3.x - left2.x) -
      //         atan2(left1.y - left2.y, left1.x - left2.x)) *
      //     180 ~/
      //     PI; // left leg curve

      if (angle < 0) {
        angle = angle + 360;
      }

      if (angler < 0) {
        angler = angler + 360;
      }
      // if (angle > 180) {
      //   angle = 360 - angle;
      // }
      if (angle1 < 0) {
        angle1 = angle1 + 360;
      }

      if (angle1r < 0) {
        angle1r = angle1r + 360;
      }
      // if (angle1 > 180) {
      //   angle1 = 360 - angle1;
      // }
      // print("Angle: $angle");
      print("Angle1: $angle1");
      // print("Angler: $angler");
      // print("Angle1r: $angle1r");

      if ((angle > 290 && angle < 330 && stage != "down" && angle1 > 180 && angle1 < 210) ||
          (angle1 > 290 && angle1 < 330 && stage != "down" && angle > 180 && angle < 210)) {
        stage = "down";
        color = Colors.green;
      }

      // if (((angle > 25 && angle < 55 && stage != "down") &&
      //         (angle1 > 80 && angle1 < 135 && stage != "down")) ||
      //     ((angler > 25 && angler < 55 && stage != "down") &&
      //         (angle1r > 80 && angle1r < 135 && stage != "down"))) {
      //   stage = "down";
      //   color = Colors.green;
      // }
      if (stage == "down") {
        color = Colors.green;
        align = true;
      } else {
        color = Colors.deepPurple;
        align = false;
      }
      if ((angle > 290 && angle < 330 && stage == "down" && angle1 > 180 && angle1 < 210) ||
          (angle1 > 290 && angle1 < 330 && stage == "down" && angle > 180 && angle < 210)) {
        counter++;
        stage = "up";
      }

      canvas.drawCircle(
        Offset(
          translateX(left1.x, rotation, size, absoluteImageSize),
          translateY(left1.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(left2.x, rotation, size, absoluteImageSize),
          translateY(left2.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(left3.x, rotation, size, absoluteImageSize),
          translateY(left3.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(right1.x, rotation, size, absoluteImageSize),
          translateY(right1.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(right2.x, rotation, size, absoluteImageSize),
          translateY(right2.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(right3.x, rotation, size, absoluteImageSize),
          translateY(right3.y, rotation, size, absoluteImageSize),
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
  bool shouldRepaint(covariant PosePainter_bicycleCrunches oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.poses != poses;
  }
}
