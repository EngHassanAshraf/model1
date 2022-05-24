import 'package:firebase_core/firebase_core.dart';
import 'package:model1/image_to_text.dart';
import 'firebase_options.dart';


import 'package:flutter/material.dart';
// import 'package:model1test/image_to_text.dart';

import 'Network/local/diohelper.dart';
import 'mainscreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Anemia Test",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData(),
      home: const MainScreen(),
    );
  }
}
