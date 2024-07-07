import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Imagetopdf extends StatefulWidget {
  @override
  _ImagetopdfState createState() => _ImagetopdfState();
}

class _ImagetopdfState extends State<Imagetopdf> {
  final ImagePicker _picker = ImagePicker();
  final pw.Document _pdf = pw.Document();
  List<File> _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_images.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/r5.png',
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select Image From Camera or Gallery',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.indigo[900],
                      fontSize: 30,
                    ),
                  ),
                  Image.asset(
                    'assets/images/r6.png',
                    height: 100,
                  ),
                ],
              ),
            )
          else
            PdfPreview(
              maxPageWidth: 1000,
              useActions: false,
              canChangePageFormat: true,
              canChangeOrientation: true,
              canDebug: false,
              build: (format) => generateDocument(format, _images),
            ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              onPressed: getImageFromGallery,
              backgroundColor: Colors.indigo[900],
              child: Icon(Icons.image),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: getImageFromCamera,
              backgroundColor: Colors.indigo[900],
              child: Icon(Icons.camera),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      setState(() {
        _images.add(imageFile);
      });
    }
  }

  Future<void> getImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      setState(() {
        _images.add(imageFile);
      });
    }
  }

  Future<Uint8List> generateDocument(
      PdfPageFormat format, List<File> images) async {
    final pw.Document doc = pw.Document();

    for (var imageFile in images) {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final pw.MemoryImage imageProvider = pw.MemoryImage(imageBytes);

      doc.addPage(
        pw.Page(
          pageFormat: format,
          build: (context) {
            return pw.Center(
              child: pw.Image(imageProvider),
            );
          },
        ),
      );
    }

    return await doc.save();
  }
}
