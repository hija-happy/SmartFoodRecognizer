import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'dart:ui' as ui;
import '../widgets/result_display.dart';
import '../models/recognition.dart';

class ImageCaptureScreen extends StatefulWidget {
  const ImageCaptureScreen({super.key});

  @override
  State<ImageCaptureScreen> createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  File? _image;
  final picker = ImagePicker();
  List<Recognition>? _recognitions;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    String? result = await Tflite.loadModel(
      model: "assets/food_detection_model.tflite",
      labels: "assets/labels.txt",
    );
    print(result);
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        detectFood(_image!);
      } else {
        print('No image selected');
      }
    });
  }

Future<void> detectFood(File imageFile) async {
  // Load the image to get its dimensions
  final bytes = await imageFile.readAsBytes();
  final ui.Image image = await decodeImageFromList(bytes);

  final recognitions = await Tflite.runModelOnImage(
    path: imageFile.path,
    numResults: 2,  // Adjust based on your requirement
    threshold: 0.5,
  );

  // Debugging: Print the recognition result to inspect its structure
  print("Recognition Result: $recognitions");

  // Convert to Recognition model
  if (recognitions != null) {
    _recognitions = recognitions.map<Recognition>((recog) {
      // Check if the 'rect' exists before accessing it
      final box = recog['rect'];

      if (box != null) {
        return Recognition(
          label: recog['label'],
          confidence: recog['confidence'],
          boundingBox: Rect.fromLTRB(
            box['x'] * image.width,
            box['y'] * image.height,
            (box['x'] + box['w']) * image.width,
            (box['y'] + box['h']) * image.height,
          ),
          imageWidth: image.width.toDouble(),   // Add original image width
          imageHeight: image.height.toDouble(),  // Add original image height
        );
      } else {
        // Return a Recognition object without bounding box if 'rect' is null
        return Recognition(
          label: recog['label'],
          confidence: recog['confidence'],
          boundingBox: Rect.zero, // No bounding box
          imageWidth: image.width.toDouble(),   // Add original image width
          imageHeight: image.height.toDouble(),  // Add original image height
        );
      }
    }).toList();
  }

  setState(() {});
}


Future<ui.Image> decodeImageFromList(Uint8List imageData) async {
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(imageData, (ui.Image img) {
    return completer.complete(img);
  });
  return completer.future;
}


  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Detection App"),
      ),
      body: Center(
        child: _image == null
            ? const Text("No Image Selected")
            : ResultDisplay(recognitions: _recognitions ?? [], image: _image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
