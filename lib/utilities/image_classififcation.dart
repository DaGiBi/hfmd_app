import 'dart:io';
// import 'dart:convert';
import 'dart:typed_data';
// import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:http/http.dart' as http;

class ImageClassificationService {
  static Future<Map<String, dynamic>> classifyImage(File imageFile, Interpreter interpreter, List<String> labels) async {
    try {
      var image = img.decodeImage(await imageFile.readAsBytes())!;
      var resizedImage = img.copyResize(image, width: 224, height: 224);
      var inputImage = preprocessImage(resizedImage);

      var input = inputImage.reshape([1, 224, 224, 3]);
      var output = List<double>.filled(2, 0).reshape([1, 2]);

      interpreter.run(input, output);

      var probabilities = output[0];
      var maxIndex = probabilities.indexOf(probabilities.reduce((double a, double b) => a > b ? a : b));
      var prediction = labels[maxIndex];
      var accuracy = probabilities[maxIndex] * 100;

      return {
        "prediction": prediction,
        "accuracy" : accuracy,
      };

    } catch (e) {
      print('Error classifying image: $e');
      throw e; 
    } finally {
      // ...
      // Rest of the code from _classifyImage function
      // ...
    }
  }

  static Uint8List preprocessImage(img.Image image) {
   var inputSize = 224;
    var inputMean = 127.5;
    var inputStd = 127.5;

    var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
    var buffer = Uint8List.view(convertedBytes.buffer);

    var pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);

        buffer[pixelIndex++] = ((pixel >> 16) & 0xFF);
        buffer[pixelIndex++] = ((pixel >> 8) & 0xFF);
        buffer[pixelIndex++] = ((pixel) & 0xFF);
      }
    }

    for (var i = 0; i < convertedBytes.length; i++) {
      var pixel = convertedBytes[i];
      convertedBytes[i] = ((pixel - inputMean) ~/ inputStd).toUnsigned(8);
    }

    return convertedBytes;
  }
}
