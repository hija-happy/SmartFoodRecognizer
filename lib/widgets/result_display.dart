// result_display.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:food_detection_app/models/recognition.dart';
import 'package:food_detection_app/widgets/bounding_box_painter.dart';


class ResultDisplay extends StatelessWidget {
  final List<Recognition> recognitions;
  final File image;
  

  const ResultDisplay({required this.recognitions, required this.image});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: decodeImageFromList(image.readAsBytesSync()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("BOX IS CALLED");
          return CustomPaint(
            size: Size(snapshot.data!.width.toDouble(), snapshot.data!.height.toDouble()),
            painter: BoundingBoxPainter(recognitions, snapshot.data!),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}