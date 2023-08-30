import 'package:flutter/material.dart';

ourTextStyle(
    {String family = "six", double? size = 14.5, color = Colors.white, double? letterSpacing = 0, FontWeight weight = FontWeight.normal}) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontFamily: family,
    letterSpacing: letterSpacing,
    fontWeight: weight,
  );
}
