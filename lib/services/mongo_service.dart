// import 'dart:convert';

// import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:hfmd_app/services/mongo_constant.dart';

enum LoginResult {
  success,
  invalidCredentials,
  error,
}

class HFMDMarker {
  final String dateDiagnose;
  final String timeDiagnose;
  final double latitude;
  final double longitude;
  final String prediction;

  HFMDMarker({
    required this.dateDiagnose,
    required this.timeDiagnose,
    required this.latitude,
    required this.longitude,
    required this.prediction,
  });

  factory HFMDMarker.fromJson(Map<String, dynamic> json) {
    final dateDiagnose = json['dateDiagnose'];
    final formattedDate = dateDiagnose.split(' ')[0]; // Extracting the date part
    final formattedTime = dateDiagnose.split(' ')[1].split('.')[0]; // Extracting the time part

    return HFMDMarker(
      dateDiagnose: formattedDate,
      timeDiagnose: formattedTime,
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
      prediction: json['prediction'],
    );
  }
}
// facilties marker
class FacilitiesMarker {
  final String facilityName;
  final double latitude;
  final double longitude;

  FacilitiesMarker({
    required this.facilityName,
    required this.latitude,
    required this.longitude,
  });

  factory FacilitiesMarker.fromJson(Map<String, dynamic> json) {

    return FacilitiesMarker(
      facilityName: json['facilityName'],
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
    );
  }
}


class MongoServices {
  final String uriString = constantUrl;

  // api for login
  Future<LoginResult> login(String username, String password) async {
    
    try {
      final db = await mongo.Db.create(constantUrl);
      await db.open();

      final usersCollection = db.collection('users');
      final query = mongo.where.eq('username', username).eq('password', password);
      final result = await usersCollection.findOne(query);
      await db.close();
      if (result != null) {
        return LoginResult.success;
      } else {
        return LoginResult.invalidCredentials;
      }
    } catch (e) {
      return LoginResult.error;
    } 
  }
// api fo user profile
  Future<Map<String, dynamic>?> getUserProfile(String username) async {
    try {
      final db = await mongo.Db.create(constantUrl);
      await db.open();

      final collection = db.collection('users');
      final userData = await collection.findOne(mongo.where.eq('username', username));

      await db.close();

      return userData;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
// api for validation
  static Future<bool> validateUsername(String username) async {
    final db = await mongo.Db.create(constantUrl);
    await db.open();

    final usersCollection = db.collection('users');
    final query = mongo.where.eq('username', username);
    final count = await usersCollection.count(query);

    await db.close();

    return count == 0;
  }
// a[i for user registration
  static Future<void> registerUser(Map<String, String> userData) async {
    final db = await mongo.Db.create(constantUrl);
    await db.open();

    final usersCollection = db.collection('users');
    await usersCollection.insert(userData);

    await db.close();
  }
  // api for fetch data based on user
  static Future<List<dynamic>> fetchData(String username) async {
    try {
      final db = await mongo.Db.create(constantUrl);
      await db.open();
      final predictionCollection = db.collection('predictions');
      print("searchinh");
      final query = mongo.where.eq('username', username);
      final data = await predictionCollection.find(query).toList();

      await db.close();
      return data;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
  // appi for fetch marker positive hfmd
  static Future<List<HFMDMarker>> fetchHotspot() async {
    try {
      final db = await mongo.Db.create(constantUrl);
      await db.open();
      final predictionCollection = db.collection('predictions');
      final query = mongo.where.eq('prediction', 'HFMD');
      final data = await predictionCollection.find(query).toList();
      await db.close();
      print("searchinh");
      return data.map((item) => HFMDMarker.fromJson(item)).toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
  // appi for fetch facilities marker  
  static Future<List<FacilitiesMarker>> fetchFacilities() async {
    try {
      final db = await mongo.Db.create(constantUrl);
      await db.open();
      final facilitesCollection = db.collection('facilities');
      final data = await facilitesCollection.find().toList();
      await db.close();
      print("searchinhg");
      return data.map((item) => FacilitiesMarker.fromJson(item)).toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // apir for save prediction result
  static Future<void> savePredictionCloud(Map<String, dynamic> data) async {
    try {
      final db = await mongo.Db.create(constantUrl);
      await db.open();

      final predictionCollection = db.collection('predictions');
      await predictionCollection.insert(data);

      await db.close();
      print('Data stored in MongoDB successfully');
    } catch (e) {
      print('Error storing data in MongoDB: $e');
    }
  }
  // apir for fetch analytic data
  static Future<List<dynamic>?> fetchAnalyticData() async {
    try {
      final db = await mongo.Db.create(constantUrl);
      await db.open();

      final predictionCollection = db.collection('predictions');
      final data = await predictionCollection.find().toList();
      await db.close();
      return data;
    } catch (e) {
      print('Error storing data in MongoDB: $e');
      return null;
    }
  }
}
