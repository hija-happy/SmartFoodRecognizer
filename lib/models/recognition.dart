import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Recognition {
  final String label;
  final double confidence;
  final Rect boundingBox;
  final double imageWidth;  // New field for original image width
  final double imageHeight; // New field for original image height

  Recognition({
    required this.label,
    required this.confidence,
    required this.boundingBox,
    required this.imageWidth,  // Add this to the constructor
    required this.imageHeight, // Add this to the constructor
  });
}
