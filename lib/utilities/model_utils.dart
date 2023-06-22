// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelService {
  static Future<Interpreter> loadModel() async {
    var interpreterOptions = InterpreterOptions();
    var interpreter = await Interpreter.fromAsset('assets/model.tflite', options: interpreterOptions);
    return interpreter;
  }
}
