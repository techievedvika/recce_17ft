import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:recce/data/exceptions/app_exceptions.dart';
import 'package:recce/data/network/base_api_services.dart';


class NetworkServicesApi implements BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
     if(kDebugMode){
      print('this is url in get $url');
     
    }
    dynamic jsonResponse;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 40));
        jsonResponse = returnResponse(response);



      if (response.statusCode == 200) {

      }
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    }
    return jsonResponse;
  }

  @override
   Future<dynamic> postApi(String url,var data) async {
    dynamic jsonResponse;
    if(kDebugMode){
      print('this is url in post $url');
      print('this is data in post $data');
    }
    try {
      final response =
          await http.post(Uri.parse(url),
          body: data
          ).timeout(const Duration(seconds: 40));
         // print('this is raw response $response');
        jsonResponse = returnResponse(response);
      //  print('this is jsonREsponse $jsonResponse');
        // print('tjis is raw respnse form api ${response.body}');

        // print('this is json response $jsonResponse');



      if (response.statusCode == 200) {

      }
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    }
    return jsonResponse;
  }
    

  //handle response status code
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic jsonResponse = jsonDecode(response.body);

        return jsonResponse;
      case 400:
        dynamic jsonResponse = jsonDecode(response.body);

        return jsonResponse;

      case 404:
        throw NotFoundException();
      case 500:
        throw PlatformException();
      case 401:
        throw UnauthorizedException();
      default:
       throw CustomException('Invalid response');
  }
}

}