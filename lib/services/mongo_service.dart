// import 'dart:convert';

// import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:hfmd_app/services/mongo_constant.dart';

enum LoginResult {
  success,
  invalidCredentials,
  error,
}

class MapMarker {
  final String dateDiagnose;
  final double latitude;
  final double longitude;
  final String prediction;

  MapMarker({
    required this.dateDiagnose,
    required this.latitude,
    required this.longitude,
    required this.prediction,
  });

  factory MapMarker.fromJson(Map<String, dynamic> json) {
    return MapMarker(
      dateDiagnose: json['dateDiagnose'],
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
      prediction: json['prediction'],
    );
  }
}

class MongoServices {
  final String uriString = constantUrl;

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

  static Future<bool> validateUsername(String username) async {
    final db = await mongo.Db.create(constantUrl);
    await db.open();

    final usersCollection = db.collection('users');
    final query = mongo.where.eq('username', username);
    final count = await usersCollection.count(query);

    await db.close();

    return count == 0;
  }

  static Future<void> registerUser(Map<String, String> userData) async {
    final db = await mongo.Db.create(constantUrl);
    await db.open();

    final usersCollection = db.collection('users');
    await usersCollection.insert(userData);

    await db.close();
  }

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

static Future<List<MapMarker>> fetchHotspot() async {
    try {
      final db = await mongo.Db.create(constantUrl);
      await db.open();
      final predictionCollection = db.collection('predictions');
      final query = mongo.where.eq('prediction', 'HFMD');
      final data = await predictionCollection.find(query).toList();
      await db.close();
      print("searchinh");
      return data.map((item) => MapMarker.fromJson(item)).toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
    
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
}
