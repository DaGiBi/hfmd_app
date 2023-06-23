import 'dart:io';
import 'dart:convert';
// import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:hfmd_app/services/mongo_service.dart';
import 'package:hfmd_app/utilities/local_storing_utils.dart';
import 'package:hfmd_app/utilities/location_utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
// import 'package:image/image.dart' as img;
// import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:hfmd_app/screens/constant.dart';
import 'package:hfmd_app/screens/info_screen.dart';

import 'package:hfmd_app/utilities/image_classififcation.dart';
import 'package:hfmd_app/utilities/model_utils.dart';
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
  String accuracy = '';
  double  _accuracy = 0.0;
  String? _selectedGender; //gender
  String? _age;   //age
  late LocationData _locationData;
  String _username = '';
  bool _isConnected = false;
  // bool _interpreterClosed = false;

  bool _isFormValid() {    
    return _age != null && _selectedGender != null;
  }

  @override
  void initState() {
    super.initState();
    _loadSession();
    _loadModel(); 
  }

    @override
  void dispose() {
    // _closeInterpreter();
    super.dispose();
  }
  Future<void> _loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final bool? isConnected = prefs.getBool('isConnected');
    final locationData = await LocationUtilities.getDeviceLocation();

    setState(() {
      _username = username ?? '';
      _isConnected = isConnected!;
      _locationData = locationData!;

    });
    _loadModel();
  }

  
  Future<void> _loadModel() async {
    setState(() {
      _isLoading = true;
    });

    try {
      
      _interpreter = await ModelServices.loadInterpreter();
      _labels = await ModelServices.loadLabel();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading model: $e');
      // _closeInterpreter();
      _loadModel();
    }
  }

  Future<void> _classifyImage() async {
    setState(() {
      _isLoading = true;
    });

     try {
      final classificationData = await ImageClassificationService.classifyImage(_imageFile!, _interpreter, _labels);
      setState(() {
        _isLoading = false;
        _prediction = classificationData["prediction"];
        _accuracy = double.parse(classificationData["accuracy"].toStringAsFixed(2));
      });

      // TESTTTING
      _prediction = "HFMD";
      accuracy = _accuracy.toString();
    // Store data locally and in MongoDB
      await _storeData(_prediction, _accuracy);
      
    // Show popup if the prediction is "HFMD"
      if (_prediction == "HFMD") {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Prediction Result'),
            content: Text('The prediction result is HFMD.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoScreen(),
                    ),
                  );
            },
            child: Text('Learn More about HFMD'),
          ),   
            ],
          ),
        );
      }
    } catch (e) {
    print('Error classifying image: $e');
  } finally {
    // Close the interpreter
    // _closeInterpreter(); 
    
    print('turn off');
  }
}

  Future<void> _storeData(String prediction, double accuracy) async {
    try {
      if(_isConnected){
        final gender = _selectedGender!;
        final age = _age!;
        final location = _locationData; // Replace 'Your Location' with the actual location
        final imageUri = base64Encode(await _imageFile!.readAsBytes());
        final locationFile = await LocationUtilities.getCityState(location);
        final state = locationFile["address"]["state"];
        final city = locationFile["address"]["city"];

        final data = {
          'username': _username,
          'gender': gender,
          'age': age,
          'dateDiagnose': DateTime.now().toString(),
          'location': {
            'latitude': location.latitude,
            'longitude': location.longitude,
            'city': city,
            'state': state
            // Add other location properties if needed
          },
          'prediction': prediction,
          'accuracy': accuracy,
          'image': imageUri,
        };
        // Store data locally
        await LocalStoringUtillities.storeLocally(data);
        
          // Store data in MongoDB via Flask server API
        await MongoServices.savePredictionCloud(data);
      }
      // offline mode
      else{
        final gender = _selectedGender!;
        final age = _age!;
        final location = _locationData; // Replace 'Your Location' with the actual location
        final imageUri = base64Encode(await _imageFile!.readAsBytes());

        final data = {
          'gender': gender,
          'age': age,
          'dateDiagnose': DateTime.now().toString(),
          'location': {
            'latitude': location.latitude,
            'longitude': location.longitude,
            // Add other location properties if needed
          },
          'prediction': prediction,
          'accuracy': accuracy,
          'image': imageUri,
        };
        // Store data locally
       await LocalStoringUtillities.storeLocally(data);
      }
    } catch (e) {
      print('Error storing data: $e');
    }
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
          Text(
            accuracy,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ), 
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoScreen(),
                ),
              );
            },
            child: Text('Learn More about HFMD'),
          ),        
        ],
      ),
    );
  }
}
