import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:hfmd_app/screens/constant.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<String> fileNames = [];
  List<dynamic> fileList = [];
  String _username = '';
  bool _isConnected = false;


  @override
  void initState() {
    super.initState();
    _loadSession();

  }
  Future<void> _loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final bool? isConnected = prefs.getBool('isConnected');
    setState(() {
      _username = username ?? '';
      _isConnected = isConnected!;
    });

    if(_isConnected){
      fetchData();
    }
    else{
      loadStoredFiles();
    }
  }
  Future<void> loadStoredFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync();

      fileNames = files
          .where((file) => file.path.endsWith('.json'))
          .map((file) => file.path)
          .toList();

      setState(() {});
    } catch (e) {
      print('Error loading stored files: $e');
    }
  }

  Future<Map<String, dynamic>> loadFileData(String fileName) async {
    try {
      final file = File(fileName);
      final jsonData = await file.readAsString();
      final data = jsonDecode(jsonData);
      return data;
    } catch (e) {
      print('Error loading file data: $e');
      return {};
    }
  }

   Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$constantUrl/get-file/$_username'));
      print(_username);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
          // print(jsonData);
          setState(() {
            fileList = jsonData;
          });
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      // fetchData();
      
    }
  }
  @override
  Widget build(BuildContext context) {
    if(_isConnected){
      return Scaffold(
      appBar: AppBar(
        title: Text('List Prediction Online'),
      ),
      body: ListView.builder(
        itemCount: fileList.length,
        itemBuilder: (context, index) {
          final fileData = fileList[index] as Map<String, dynamic>;
          final imageBase64 = fileData['image'];
          final imageBytes = base64Decode(imageBase64);
          final imageWidget = Image.memory(imageBytes);

          return Card(
            child: ListTile(
              title: Text('File Name: ${fileData['username']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gender: ${fileData['gender']}'),
                  Text('Age: ${fileData['age']}'),
                  Text('Location: Latitude ${fileData['location']['latitude']}, Longitude ${fileData['location']['longitude']}'),
                  Text('Location: State ${fileData['location']['state']}, City ${fileData['location']['city']}'),
                  Text('Prediction: ${fileData['prediction']}'),
                  Text('Accuracy: ${fileData['accuracy']}'),
                  Text('Username: ${fileData['username']}'),
                  Text('Date: ${fileData['dateDiagnose']}'),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: imageWidget,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    }
    else{
        return Scaffold(
        appBar: AppBar(
          title: Text('List Prediction Offline'),
        ),
        body: ListView.builder(
          itemCount: fileNames.length,
          itemBuilder: (context, index) {
            final fileName = fileNames[index];
            return FutureBuilder(
              future: loadFileData(fileName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    title: Text('Loading...'),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text('Error loading file'),
                  );
                } else {
                  final fileData = snapshot.data as Map<String, dynamic>;
                  final imageBase64 = fileData['image'];
                  final imageBytes = base64Decode(imageBase64);
                  final imageWidget = Image.memory(imageBytes);

                  return Card(
                    child: ListTile(
                      title: Text('File Name: $fileName'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gender: ${fileData['gender']}'),
                          Text('Age: ${fileData['age']}'),
                          Text('Location: Latitude ${fileData['location']['latitude']}, Longitude ${fileData['location']['longitude']}'),
                          // Text('Location: State ${fileData['location']['state']}, City ${fileData['location']['city']}'),
                          Text('Prediction: ${fileData['prediction']}'),
                          Text('Accuracy: ${fileData['accuracy']}'),
                          Text('Username: ${fileData['username']}'),
                          Text('date: ${fileData['dateDiagnose']}'),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            child: imageWidget,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      );
    }
    
  }
}
