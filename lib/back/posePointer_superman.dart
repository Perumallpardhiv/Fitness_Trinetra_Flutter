import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:trinetraflutter/translator.dart';
import 'package:trinetraflutter/values_timer.dart';

class PosePointer_Superman extends CustomPainter {
  final List<Pose> poses;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final int minangle;
  final int minangle2;
  final int maxangle;
  final int maxangle2;
  final PoseLandmarkType pos1;
  final PoseLandmarkType pos2;
  final PoseLandmarkType pos3;

  PosePointer_Superman(
    this.poses,
    this.absoluteImageSize,
    this.rotation,
    this.minangle,
    this.minangle2,
    this.maxangle,
    this.maxangle2,
    this.pos1,
    this.pos2,
    this.pos3,
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
      final pos11 = pose.landmarks[pos1]!; //ear
      final pos12 = pose.landmarks[pos2]!; //hip
      final pos13 = pose.landmarks[pos3]!; //knee

      angle = (atan2(pos13.y - pos12.y, pos13.x - pos12.x) -
              atan2(pos11.y - pos12.y, pos11.x - pos12.x)) *
          180 ~/
          PI;

      if (angle < 0) {
        angle = angle * -1;
      }

      print("Angle: $angle");

      if (angle > 135 && angle < 160) {
        color = Colors.green;
        align = true;
        counter1++;
        if (counter1 % 10 == 0) {
          timer++;
        }
      } else {
        color = Colors.deepPurple;
        align = false;
      }

      canvas.drawCircle(
        Offset(
          translateX(pos11.x, rotation, size, absoluteImageSize),
          translateY(pos11.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(pos12.x, rotation, size, absoluteImageSize),
          translateY(pos12.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      canvas.drawCircle(
        Offset(
          translateX(pos13.x, rotation, size, absoluteImageSize),
          translateY(pos13.y, rotation, size, absoluteImageSize),
        ),
        1,
        dot,
      );

      void paintLine(
        PoseLandmarkType type1,
        PoseLandmarkType type2,
        Paint paintType,
      ) {
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
      paintLine(pos1, pos2, paint..color = color);
      paintLine(pos2, pos3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PosePointer_Superman oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.poses != poses;
  }
}
