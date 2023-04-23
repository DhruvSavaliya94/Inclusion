// import 'dart:async';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final cameras = await availableCameras();
//   //final firstCamera = cameras.first;
//   CameraDescription frontCamera = cameras.firstWhere(
//         (camera) => camera.lensDirection == CameraLensDirection.front,
//   );
//   runApp(MyApp(camera: frontCamera));
// }
//
// class MyApp extends StatelessWidget {
//   final CameraDescription camera;
//
//   MyApp({required this.camera});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Face Gesture Recognition',
//       home: FaceGestureRecognition(camera: camera),
//     );
//   }
// }
//
// class FaceGestureRecognition extends StatefulWidget {
//   final CameraDescription camera;
//
//   const FaceGestureRecognition({Key? key, required this.camera})
//       : super(key: key);
//
//   @override
//   _FaceGestureRecognitionState createState() => _FaceGestureRecognitionState();
// }
//
// class _FaceGestureRecognitionState extends State<FaceGestureRecognition> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   late FaceDetector _faceDetector;
//   bool _isDetecting = false;
//   String _gesture = 'No gesture detected';
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = CameraController(widget.camera, ResolutionPreset.high);
//     _initializeControllerFuture = _controller.initialize();
//
//     _faceDetector = GoogleMlKit.vision.faceDetector(
//       FaceDetectorOptions(
//         enableClassification: true,
//         enableTracking: true,
//         minFaceSize: 0.15,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _faceDetector.close();
//     super.dispose();
//   }
//
//   void _startDetection() {
//     _isDetecting = true;
//     _controller.startImageStream((image) async {
//       if (!_isDetecting) {
//         return;
//       }
//
//       final inputImage = InputImage.fromBytes(
//         bytes: image.planes.first.bytes,
//         inputImageData: InputImageData(
//           size: Size(image.width.toDouble(), image.height.toDouble()),
//           imageRotation: InputImageRotation.rotation90deg,
//           inputImageFormat: InputImageFormat.yuv420,
//           planeData: image.planes.map((plane) {
//             return InputImagePlaneMetadata(
//               bytesPerRow: plane.bytesPerRow,
//               height: plane.height,
//               width: plane.width,
//             );
//           }).toList(),
//         ),
//       );
//
//       final faces = await _faceDetector.processImage(inputImage);
//
//       if (faces.isNotEmpty) {
//         setState(() {
//           final face = faces.first;
//
//           if (face.headEulerAngleY! > 20) {
//             _gesture = 'Looking up';
//           } else if (face.headEulerAngleY! < -20) {
//             _gesture = 'Looking down';
//           } else if (face.headEulerAngleZ! > 20) {
//             _gesture = 'Looking left';
//           } else if (face.headEulerAngleZ! < -20) {
//             _gesture = 'Looking right';
//           } else {
//             _gesture = 'No gesture detected';
//           }
//         });
//       }
//
//     });
//   }
//
//   void _stopDetection() {
//     _isDetecting = false;
//     _controller.stopImageStream();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Face Gesture Recognition'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 1,
//             child: FutureBuilder<void>(
//               future: _initializeControllerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return CameraPreview(_controller);
//                 } else {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//               },
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               alignment: Alignment.center,
//               color: Colors.grey[300],
//               child: Text(
//                 _gesture,
//                 style: const TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.symmetric(vertical: 16),
//             alignment: Alignment.center,
//             child: ElevatedButton(
//               onPressed: () {
//                 _startDetection();
//                 if (_isDetecting) {
//                   _stopDetection();
//                 } else {
//                   _startDetection();
//                 }
//               },
//               child: Text(_isDetecting ? 'Stop' : 'Start'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
