
import 'package:flutter/material.dart';
import 'package:food_detection_app/screens/image_capture.dart';

void main() {
  runApp(const FoodDetection());
}

class FoodDetection extends StatelessWidget {
  const FoodDetection({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Detection App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const ImageCaptureScreen(),
    );
  }
}


