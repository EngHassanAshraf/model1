// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'Network/local/diohelper.dart';
import 'Network/remote/remotedeiohelper.dart';
// import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color malebuttonColor = Colors.grey;
  Color femalebuttonColor = Colors.grey;

  int male = 0;
  int female = 0;
  bool isMale = false;
  bool isFemale = false;

  String result = "";
  // List<User> result1 = [];

  var hemoController = TextEditingController();
  var mchController = TextEditingController();
  var mchcController = TextEditingController();
  var mcvController = TextEditingController();

  // final String baseUrl = "http://127.0.0.1:8000";

  // void _fetchResultsFromAPI() async {
  //   final Dio dio = new Dio();

  //   try {
  //     var response = await dio.get(
  //         "$baseUrl/classify/?hemoglobin=11&mch=20.5&mchc=15.8&mcv=68.4&gender=male");
  //     print(response.statusCode);
  //     var responseData = response.data as List;

  //     setState(() {
  //       result1 = responseData.map((e) => User.fromJson(e).toMap());
  //     });
  //   } on DioError catch (e) {
  //     print(e);
  //   }
  // }

  // File? image;
  // Future pickImg(imagesource) async {
  //   try {
  //     final img = await ImagePicker().pickImage(source: imagesource);

  //     if (img == null) return;

  //     final imgTemp = File(img.path);
  //     print("IMAGE PATH::: ${img.path}");
  //     setState(() {
  //       image = imgTemp;
  //     });
  //   } on PlatformException catch (e) {
  //     if (kDebugMode) {
  //       print('Failed to pick an image: $e');
  //     }
  //   }
  // }

  static Uint8List? pickedImg;
  static String? pickedImgName;
  static String? pickedImgEx;
  static String? pickedImgpath;
  static String? imgUrl;
  Future pickImg() async {
    FilePickerResult? image = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    pickedImg = image!.files.single.bytes;
    pickedImgName = image.files.single.name;
    pickedImgEx = image.files.single.extension;
    pickedImgpath = image.files.single.path;
    imageUpload(pickedImg!);
    print("Image $pickedImgpath");
  }

  static final analysisRef =
      FirebaseStorage.instance.ref().child("$pickedImgName");

  static void imageUpload(pickedImage) {
    var imgUpload = analysisRef.putData(pickedImage);
    imgUpload.whenComplete(() async {
      imgUrl = await imgUpload.snapshot.ref.getDownloadURL();
      print("UPLOADADADA IMAGEGE:: $imgUrl");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Anemia Test",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                style: const TextStyle(fontSize: 20.0),
                decoration: const InputDecoration(
                  labelText: "Hemo Value",
                  hintStyle: TextStyle(fontSize: 25.0),
                ),
                keyboardType: TextInputType.number,
                controller: hemoController,
              ),
              TextField(
                style: const TextStyle(fontSize: 20.0),
                decoration: const InputDecoration(
                  labelText: "MCH Value",
                  hintStyle: TextStyle(fontSize: 25.0),
                ),
                keyboardType: TextInputType.number,
                controller: mchController,
              ),
              TextField(
                style: const TextStyle(fontSize: 20.0),
                decoration: const InputDecoration(
                  labelText: "MCHC Value",
                  hintStyle: TextStyle(fontSize: 25.0),
                ),
                keyboardType: TextInputType.number,
                controller: mchcController,
              ),
              TextField(
                style: const TextStyle(fontSize: 20.0),
                decoration: const InputDecoration(
                  labelText: "MCV Value",
                  hintStyle: TextStyle(fontSize: 25.0),
                ),
                keyboardType: TextInputType.number,
                controller: mcvController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: malebuttonColor,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isMale = !isMale;
                              isFemale = !isFemale;
                              malebuttonColor = Colors.amber;
                              femalebuttonColor = Colors.grey;
                            });
                          },
                          icon: const Icon(Icons.male),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: femalebuttonColor,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isMale = !isMale;
                              isFemale = !isFemale;
                              malebuttonColor = Colors.grey;
                              femalebuttonColor = Colors.amber;
                            });
                          },
                          icon: const Icon(Icons.female),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    DioHelper.getData(
                      path: "/mainmodels/anemiaclassify/?",
                      queryPara: {
                        "hemoglobin": hemoController.text,
                        "mch": mchController.text,
                        "mchc": mchcController.text,
                        "mcv": mcvController.text,
                        "gender": isMale ? '0' : '1'
                      },
                    ).then((value) {
                      print("\n\nSTATUS::::: ${value.statusCode}\n\n");
                      result = value.data['results']['Animea Test'].toString();
                      print("result:::: $result");
                    }).catchError((error) {
                      print("Errororor" + error.toString());
                    });
                  });
                },
                child: const Text("Result"),
                textColor: Colors.white,
                color: Colors.blue,
              ),
              SizedBox(height: 10),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    RemoteDioHelper.getData(
                      path: "image_to_text/url",
                      queryPara: {
                        "url": imgUrl,
                        "apikey": "R8LGtg5m8NRrMXAkyxz6VBVFrmy8j977"
                      },
                    ).then((value) {
                      result = value.data;
                      print(value.realUri);
                      print("result::> ${value.statusCode}");
                      print("result::> $result");
                    }).catchError((error) {
                      print("Errororor::> " + error.toString());
                    });
                  });
                },
                child: Text("Api Result"),
                textColor: Colors.white,
                color: Colors.blue,
              ),
              SizedBox(height: 10),
              Text("""hemoglobin: ${hemoController.text} 
mch: ${mchController.text}
mchc: ${mchcController.text}
mcv: ${mcvController.text}
gender: ${isMale ? 'Male' : 'Female'}
$result"""),
              pickedImgpath != null
                  ? Image.file(File(pickedImgpath!))
                  : Text(pickedImgpath.toString() + "1"),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // imgpicked = pickImg(ImageSource.gallery);
          pickImg();
        },
        child: Icon(Icons.add_a_photo_outlined),
      ),
    );
  }
}
