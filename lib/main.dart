import 'package:flutter/material.dart';
import 'forms/basic_information_form.dart';

import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:hive_flutter/hive_flutter.dart';

//remove me
import 'examples/google_ml_kit_example.dart';

void main() async
{

  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  // initialize Hive
  //await Hive.initFlutter();

  //runApp(MyApp(camera: firstCamera));
  runApp(InclusionApp());
}

class InclusionApp extends StatelessWidget {
  final int primaryColor = int.parse('1c1c1e', radix: 16);

  final MaterialColor primaryMaterialColor = const MaterialColor(
    0xFF1C1C1E, // Primary color value
    <int, Color>{
      50: Color(0xFFF4F9FA), // Shade 50
      100: Color(0xFFD9E7EB), // Shade 100
      200: Color(0xFFADC5CE), // Shade 200
      300: Color(0xFF81A3B2), // Shade 300
      400: Color(0xFF5C8D9A), // Shade 400
      500: Color(0xFF387684), // Shade 500
      600: Color(0xFF326F7A), // Shade 600
      700: Color(0xFF2B6470), // Shade 700
      800: Color(0xFF245965), // Shade 800
      900: Color(0xFF17484B), // Shade 900
    },
  );

  InclusionApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: primaryMaterialColor,
      ),
      home: const InclusionHomePage(title: 'Inclusion'),
    );
  }
}

class InclusionHomePage extends StatefulWidget {
  const InclusionHomePage({super.key, required this.title});

  final String title;

  @override
  State<InclusionHomePage> createState() => _InclusionHomePageState();
}

class _InclusionHomePageState extends State<InclusionHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome to Inclusion',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BasicInformationForm(),
                    ),
                  );
                },
                child: const Text('Let\'s get started!'),
              ),
              // const SizedBox(height: 16),
              // const CircularProgressIndicator(),

            ],
          ),
        ));
  }
}