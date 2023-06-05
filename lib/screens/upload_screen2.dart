// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;

// class UploadScreen extends StatefulWidget {
//   @override
//   _UploadScreenState createState() => _UploadScreenState();
// }

// class _UploadScreenState extends State<UploadScreen> {
//   File? _image;
//   String? _recognizedResult;
//   bool _isRecognizing = false;
//   late Interpreter _interpreter;

//   @override
//   void initState() {
//     super.initState();
//     _loadModel();
//   }

//   Future<void> _loadModel() async {
//     final appDir = await getApplicationDocumentsDirectory();
//     final modelPath = path.join(appDir.path, 'model.tflite');
//     _interpreter = await Interpreter.fromAsset(modelPath);
//   }

//   Future<void> _pickImage() async {
//     final imagePicker = ImagePicker();
//     final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       setState(() {
//         _image = File(pickedImage.path);
//         _recognizedResult = null;
//       });

//       _recognizeImage();
//     }
//   }

//   Future<void> _recognizeImage() async {
//     if (_image == null || _isRecognizing) return;

//     setState(() {
//       _isRecognizing = true;
//     });

//     final imageBytes = await _image!.readAsBytes();
//     // Perform image recognition using TensorFlow Lite
//     // Example code for running inference with the interpreter
//     final inputShape = _interpreter.getInputTensor(0).shape;
//     final inputType = _interpreter.getInputTensor(0).type;

//      final input = TensorImage(inputType);
//     input.loadFromList(imageBytes, inputShape);

//     final output = List.generate(
//       _interpreter.getOutputTensor(0).shape[0],
//       (index) => List.filled(_interpreter.getOutputTensor(0).shape[1], 0),
//     ).reshape(_interpreter.getOutputTensor(0).shape);

//     _interpreter.run(input.buffer, output.buffer);

//     // Post-process the output if needed
//     // Analyze the output and extract the recognition result

//     final result = 'Recognition result'; // Replace with your actual result

//     setState(() {
//       _recognizedResult = 'Recognition result';
//       _isRecognizing = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Upload')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_image != null)
//               Image.file(
//                 _image!,
//                 width: 200,
//                 height: 200,
//               ),
//             ElevatedButton(
//               child: Text('Load Image'),
//               onPressed: _pickImage,
//             ),
//             if (_recognizedResult != null)
//               Text(_recognizedResult!),
//           ],
//         ),
//       ),
//     );
//   }
// }
