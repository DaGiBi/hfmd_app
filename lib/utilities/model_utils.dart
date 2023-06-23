// import 'dart:io';
// import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelServices {
  static Future<Interpreter> loadInterpreter() async {
    var interpreterOptions = InterpreterOptions();
    var interpreter = await Interpreter.fromAsset('assets/model.tflite', options: interpreterOptions);
    return interpreter;
  }

  static Future<List<String>> loadLabel() async {
    var labelsData = await rootBundle.loadString('assets/label.txt');
    var labels = labelsData.split('\n');
    return labels;
  }

}

