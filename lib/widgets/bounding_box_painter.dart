// bounding_box_painter.dart
import 'dart:ui' as ui;


import 'package:flutter/material.dart';

import 'package:food_detection_app/models/recognition.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<Recognition> recognitions;
  final ui.Image image;

  BoundingBoxPainter(this.recognitions, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    for (var recognition in recognitions) {
      final rect = recognition.boundingBox;
      canvas.drawRect(
        Rect.fromPoints(
          Offset(rect.left, rect.top),
          Offset(rect.right, rect.bottom),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return false;
  }
}