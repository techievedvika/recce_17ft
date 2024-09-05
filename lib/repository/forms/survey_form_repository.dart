import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:recce/configs/app_urls.dart';
import 'package:recce/data/network/network_api_services.dart';
import 'package:recce/models/survery/survey_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SurveyFormRepository {
  final _api = NetworkServicesApi();

  //Upload photo and get url
  Future<String?> uploadPhoto(File photo) async {

   

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(AppUrls.imgUploadUrl));

      // Add the photo file to the request
      var photoStream = http.ByteStream(photo.openRead());
      var photoLength = await photo.length();
      var photoMultipartFile = http.MultipartFile(
        'file', // The name of the field in the form-data
        photoStream,
        photoLength,
        filename: photo.uri.pathSegments.last,
        //contentType: MediaType.parse(mime(photo.path) ?? 'application/octet-stream'),
      );

      request.files.add(photoMultipartFile);

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response body to get the URL
        var responseBody = await response.stream.bytesToString();
        // Assuming the server responds with a JSON object containing the URL
        // You may need to adjust this based on your server's response format
        var data = jsonDecode(responseBody);
        print('this is repsonse by phot $data');
        return data['url']; // The key should match the server's response
      } else {
        // Handle error response
        print('Failed to upload photo. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred while uploading photo: $e');
      return null;
    }
  }

  //Submit Form
Future<SurveyModel> submitSurveyForm(dynamic data,String id) async {
   Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

String? userid  =  await getUserId();
  if (kDebugMode) {
    print('This is JSON format: $data');
  print('Encoded JSON: ${jsonEncode(data)}');
  

  }
 var postData = {
    "collection": data,
    "created_by": userid,
    "form_Id": id
  };

 if (kDebugMode) {
   print('post data $postData');
 }

  try {
    // Make the API call
    var response = await _api.postApi(AppUrls.surveyformapi, postData);
    
    // Print the response for debugging
    print('Response from submit survey form API: $response');

    // Ensure response is not null and parse it
    if (response != null && response is Map<String, dynamic>) {
      // Deserialize JSON to SurveyModel
      SurveyModel surveyModel = SurveyModel.fromJson(response);

      // Print the SurveyModel to verify deserialization
      print('Deserialized SurveyModel: $surveyModel');
      
      return surveyModel;
    } else {
      throw Exception('Invalid response format');
    }
  } catch (e) {
    // Print error and rethrow it
    print('Error parsing submit survey form response: $e');
    rethrow;
  }
}



Future<String> fetchSchoolNames(String udiseCode) async {
  final url = AppUrls.getSchoolNamesUrl(udiseCode);
  print('this is udise code for the school names$udiseCode');
  final response = await _api.getApi(url); // Use the http package for the request
try{

  print('this is resposne form api $response');
    print(response);
  if (response !=null) {
    // Parse the JSON response
  //  final dynamic data = jsonDecode(response.body);
    print('this is resposne form api $response');
    print(response);
    // setState(() {
    //   _schoolNames = data.cast<String>(); // Assuming the API returns a list of school names
    // });
    return response.toString();
  } 
  else {
    // Handle errors
    print('Failed to load school names');

  
      throw Exception('Invalid response format');
    }
  } catch (e) {
    // Print error and rethrow it
    print('Error parsing fetch school survey form response: $e');
    rethrow;
  }
}


}
