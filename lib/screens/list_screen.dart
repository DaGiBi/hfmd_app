import 'package:flutter/material.dart';
import 'package:hfmd_app/services/mongo_service.dart';
import 'package:hfmd_app/utilities/local_storing_utils.dart';
// import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/location_utils.dart';
// import 'package:http/http.dart' as http;
// import 'package:hfmd_app/screens/constant.dart';

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

  

   Future<void> fetchData() async {
    try {
      final data = await MongoServices.fetchData(_username);

      setState(() {
        fileList = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if(_isConnected){
      return Scaffold(
      appBar: AppBar(
        title: Text('List Prediction Online'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0), // Adjust the padding value as needed
          child:ListView.builder(
          itemCount: fileList.length,
          itemBuilder: (context, index) {
            final fileData = fileList[index] as Map<String, dynamic>;
            final imageBase64 = fileData['image'];
            final imageBytes = base64Decode(imageBase64);
            final imageWidget = Image.memory(
                  imageBytes,
                  height: 100, 
                  width: 200, 
                );

            return Card(
              child: ListTile(
                title: Text('Result: ${fileData['prediction']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      child: imageWidget,
                    ),
                    Text('\nAccuracy: ${fileData['accuracy']}'),
                    Text('Username: ${fileData['username']}'),
                    Text('Date: ${fileData['dateDiagnose']}'),
                    Text('Gender: ${fileData['gender']},\t Age: ${fileData['age']}'),
                    const Text("Location:"),
                    Text('\t\t\tState: ${fileData['location']['state']}, City: ${fileData['location']['city']}'),
                    const SizedBox(height: 2),
                    ElevatedButton(
                      onPressed: () => LocationUtilities.openGoogleMaps(
                        fileData['location']['latitude'].toString(),
                        fileData['location']['longitude'].toString(),
                      ),
                      child: const Text('Open Location in Map'),
                    ),
                    
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    }
    else{
        return Scaffold(
        appBar: AppBar(
          title: Text('List Prediction Offline'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Adjust the padding value as needed
          child: ListView.builder(
            itemCount: fileNames.length,
            itemBuilder: (context, index) {
              final fileName = fileNames[index];
              return FutureBuilder(
                future: LocalStoringUtillities.loadFileData(fileName),
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
                    final imageWidget = Image.memory(
                      imageBytes,
                      height: 100, 
                      width: 200, 
                    );

                    return Card(
                      child: ListTile(
                        title: Text('Result: ${fileData['prediction']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.center,
                              child: imageWidget,
                            ),
                            Text('\nAccuracy: ${fileData['accuracy']}'),
                            Text('Date: ${fileData['dateDiagnose']}'),
                            Text('Gender: ${fileData['gender']},\t Age: ${fileData['age']}'),
                            const Text("Location:"),
                            Text('\t\t\Latitude: ${fileData['location']['latitude']}, Longitude: ${fileData['location']['longitude']}'),
                            const SizedBox(height: 2),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      );
    }
    
  }
}
