// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class OCR extends StatefulWidget {
  const OCR({Key? key}) : super(key: key);
  @override
  State<OCR> createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  File? image;

  Future pickImage(imagesource) async {
    try {
      final image = await ImagePicker().pickImage(source: imagesource);

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick an image: $e');
    }
  }

  Future textRecoer() async {
    double hgbTop = 0, hgbBottom = 0;
    double mcvTop = 0, mcvBottom = 0;
    double mchTop = 0, mchBottom = 0;
    double mchcTop = 0, mchcBottom = 0;
    int mchControl = 0;
    Map values = {'HGB': '', 'MCV': '', 'MCH': '', 'MCHC': ''};
    List hgbV = [];
    List mcvV = [];
    List mchV = [];
    List mchcV = [];

    if (image == null) pickImage(ImageSource.gallery);
    final inputImage = InputImage.fromFile(image!);
    final textReco = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textReco.processImage(inputImage);

    for (TextBlock block in recognizedText.blocks) {
      final List<TextLine> lines = block.lines;
      for (TextLine line in lines) {
        // HGB
        if (line.text.contains('HGB') ||
            line.text.contains('Hgb') ||
            line.text.contains('Haemoglobin') ||
            line.text.contains('haemoglobin') ||
            line.text.contains('Hemoglobin') ||
            line.text.contains('hemoglobin')) {
          hgbTop = block.boundingBox.top;
          hgbBottom = block.boundingBox.bottom;
          print("found HGB at top $hgbTop and bottom $hgbBottom");
        }

        // MCV
        if (line.text.contains('MCV') ||
            line.text.contains('mcv') ||
            line.text.contains('M.C.V.')) {
          mcvTop = block.boundingBox.top;
          mcvBottom = block.boundingBox.bottom;
          print("found MCV at top $mcvTop and bottom $mcvBottom");
        }

        // MCH
        if (line.text.contains('MCH') ||
            line.text.contains('mch') ||
            line.text.contains('M.C.H.')) {
          if (mchControl == 0) {
            mchControl++;
            mchTop = block.boundingBox.top;
            mchBottom = block.boundingBox.bottom;
            print("found MCH at top $mchTop and bottom $mchBottom");
          }
        }

        // MCHC
        if (line.text.contains('MCHC') ||
            line.text.contains('mchc') ||
            line.text.contains('M.C.H.C.')) {
          mchcTop = block.boundingBox.top;
          mchcBottom = block.boundingBox.bottom;
          print("found MCHC at top $mchcTop and bottom $mchcBottom");
        }
      }
    }
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        //mch
        if (hgbTop != 0 &&
            ((block.boundingBox.top - hgbTop).abs() < 10 ||
                (block.boundingBox.bottom - hgbBottom).abs() < 10)) {
          hgbV.add(line.text);
        }
        //mcv
        if (mcvTop != 0 &&
            ((block.boundingBox.top - mcvTop).abs() < 10 ||
                (block.boundingBox.bottom - mcvBottom).abs() < 10)) {
          mcvV.add(line.text);
        }

        //mch
        if (mchTop != 0 &&
            ((block.boundingBox.top - mchTop).abs() < 10 ||
                (block.boundingBox.bottom - mchBottom).abs() < 10)) {
          mchV.add(line.text);
        }

        //mchc
        if (mchcTop != 0 &&
            ((block.boundingBox.top - mchcTop).abs() < 10 ||
                (block.boundingBox.bottom - mchcBottom).abs() < 10)) {
          mchcV.add(line.text);
        }
      }
    }
    for (var item in hgbV) {
      double.tryParse(item) != null ? values['HGB'] = item : '-';
    }
    for (var item in mcvV) {
      double.tryParse(item) != null ? values['MCV'] = item : '-';
    }

    for (var item in mchV) {
      double.tryParse(item) != null ? values['MCH'] = item : '-';
    }

    for (var item in mchcV) {
      double.tryParse(item) != null ? values['MCHC'] = item : '-';
    }

    print(values);

    textReco.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DEMO OCR"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              image != null ? Image.file(image!) : FlutterLogo(),
              MaterialButton(
                onPressed: () {
                  textRecoer();
                },
                child: Icon(Icons.check_sharp),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickImage(ImageSource.gallery);
        },
        tooltip: 'load image',
        child: const Icon(Icons.add_a_photo_outlined),
      ),
    );
  }
}
