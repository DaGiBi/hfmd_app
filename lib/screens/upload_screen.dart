import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _imageFile; //image
  late Interpreter _interpreter;
  List<String> _labels = [];
  bool _isLoading = false;
  String _prediction = ''; //predition label
  double  _accuracy = 0.0;
  String? _selectedGender; //gender
  String? _age;   //age
  late LocationData _locationData;
  String _username = '';
  bool _isConnected = false;

  bool _isFormValid() {    
    return _age != null && _selectedGender != null;
  }

  @override
  void initState() {
    super.initState();
    _loadModel(); _loadSession();
  }
  Future<void> _loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final bool? isConnected = prefs.getBool('isConnected');
    setState(() {
      _username = username ?? '';
      _isConnected = isConnected!;
    });
  }
  Future<void> _loadModel() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var interpreterOptions = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset('assets/model.tflite',
          options: interpreterOptions);

      var labelsData = await rootBundle.loadString('assets/label.txt');
      _labels = labelsData.split('\n');

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading model: $e');
    }
  }
  Future<void> _pickLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() async{
        _locationData = await location.getLocation();
      });
  }
  
  Future<void> _classifyImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var image = img.decodeImage(await _imageFile!.readAsBytes())!;
      var resizedImage = img.copyResize(image, width: 224, height: 224);
      var inputImage = _preprocessImage(resizedImage);

      var input = inputImage.reshape([1, 224, 224, 3]);
      var output = List<double>.filled(2, 0).reshape([1, 2]);

      _interpreter.run(input, output);

      var probabilities = output[0];
      var maxIndex = probabilities.indexOf(probabilities.reduce((double a, double b) => a > b ? a : b));
      var prediction = _labels[maxIndex];
      var accuracy = probabilities[maxIndex] * 100; // Calculate the prediction accuracy

    setState(() {
      _isLoading = false;
      _prediction = '$prediction\n Accuracy:${accuracy.toStringAsFixed(2)}%}'; // Display the prediction and accuracy
      _accuracy = double.parse(accuracy.toStringAsFixed(2));
    });

    // Store data locally and in MongoDB
      await _storeData(prediction, _accuracy);

  } catch (e) {
    print('Error classifying image: $e');
  }
}


  // Future<Map<String, dynamic>> _getAddress(LocationData location) async{
  //   final latitude = location.latitude;
  //   final longitude = location.longitude;
  //   final apiUrl = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=10&format=json&limit=1';

  //   try {
  //     final response = await http.get(Uri.parse(apiUrl));

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
  //       return jsonData;
  //     } else {
  //       print('Failed to fetch location data. Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching location data: $e');
  //   }
  //   return {};
  // }
  Future<void> _storeData(String prediction, double accuracy) async {
    try {
      final gender = _selectedGender!;
      final age = _age!;
      final location = _locationData; // Replace 'Your Location' with the actual location
      final imageUri = base64Encode(await _imageFile!.readAsBytes());
      // final locationFile = await _getAddress(location);
      // final state = locationFile["address"]["state"];
      // final city = locationFile["address"]["city"];
      // Store data locally
      await _storeLocally(gender, age, location, prediction, accuracy, imageUri);
      if(_isConnected)
        // Store data in MongoDB via Flask server API
        await _storeInMongoDB(gender, age, location, prediction, accuracy, imageUri);
    } catch (e) {
      print('Error storing data: $e');
    }
  }

  Future<void> _storeLocally(
    String gender, String age, LocationData location, String prediction, double accuracy, String image) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final storedFile = {
      'username': _username,
      'date': DateTime.now().toString(),
      'gender': gender,
      'age': age,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
        // 'state': state,
        // 'city': city
        // Add other location properties if needed
      },
      'prediction': prediction,
      'accuracy': accuracy,
      'image': image,
    };

    final directory = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().toString() + '.json';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(jsonEncode(storedFile));

    await prefs.setString('stored_file', fileName);

    print('Data stored locally successfully');
  } catch (e) {
    print('Error storing data locally: $e');
  }
}

  Future<void> _storeInMongoDB(
      String gender, String age, LocationData location, String prediction, double accuracy,  String image) async {
    try {
      final apiUrl = 'http://192.168.0.110:5000/login'; // Replace with your actual API endpoint

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'gender': gender,
          'age': age,
          'location': {
          'latitude': location.latitude,
          'longitude': location.longitude,
          // Add other location properties if needed
          },
          'prediction': prediction,
          'accuracy': accuracy,
          'image': image,
        }),
      );

      if (response.statusCode == 200) {
        print('Data stored in MongoDB successfully');
      } else {
        print('Failed to store data in MongoDB');
      }
    } catch (e) {
      print('Error storing data in MongoDB: $e');
    }
  }
  Uint8List _preprocessImage(img.Image image) {
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

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        _prediction = '';
      });
      _classifyImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Recognition'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _age = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedGender,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    items: <String>[
                      'Male',
                      'Female',
                      'Other',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 200,
                  )
                : Text('No image selected'),
          ),
          SizedBox(height: 20),
          _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    if (_isFormValid()) {
                      _pickLocation();
                      _pickImage();
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Incomplete Form'),
                          content: Text('Please fill in all the required fields.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text('Pick Image'),
                ),
          SizedBox(height: 20),
          Text(
            _prediction,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),         
        ],
      ),
    );
  }
}
