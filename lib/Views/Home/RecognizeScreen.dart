import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class Recognizescreen extends StatefulWidget {
  File image;
  Recognizescreen({required this.image});

  @override
  State<Recognizescreen> createState() => _RecognizescreenState();
}

class _RecognizescreenState extends State<Recognizescreen> {
  late TextRecognizer textRecognizer;
  @override
  void initState() {
    super.initState();
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    doTextRecognition();
  }

  String result = '';
  doTextRecognition() async {
    InputImage inputImage = InputImage.fromFile(this.widget.image);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    result = recognizedText.text;
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Recognize',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [
              Image.file(this.widget.image),
              Card(
                  child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.document_scanner,
                          color: Colors.black,
                          size: 25,
                        ),
                        Text(
                          'Results',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Icon(
                          Icons.copy,
                          color: Colors.black,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                  Text(result),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
