import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:recce/configs/app_urls.dart';

class LoadFormRepository {
  List<String> formNames = [];

  Future<List<Map<String, dynamic>>> newfetchFormDetails1() async {
    
    final response = await http.get(Uri.parse(AppUrls.loadformapi));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> jsonData = json.decode(response.body);

        return jsonData.cast<Map<String, dynamic>>();
      } catch (e) {
        if (kDebugMode) {
          print('Error during parsing: $e');
        }
        throw Exception('Failed to parse form details: $e');
      }
    } else {
      throw Exception('Failed to load form details');
    }
  }
}
