import 'package:recce/configs/app_urls.dart';
import 'package:recce/data/network/network_api_services.dart';
import 'package:recce/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  final _api = NetworkServicesApi();

  //login method
  Future<UserModel?> loginApi(dynamic data) async {
    final response = await _api.postApi(AppUrls.loginapi, data);
  //  print('Response from login API: $response $data');

    try {
      if (response['status'] == 0 || response['user'] == null) {
        // Handle the case where credentials are invalid or user is not found
        return UserModel(
            message: response['message'],
            status: response['status'],
            user: response['user']);
      }

      // Deserialize JSON to UserModel
      if (response['user'] != null) {
        UserModel userModel = UserModel.fromJson(response);

        // Store the user ID in SharedPreferences

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userModel.user!.empId.toString());
        return userModel;
      }
    } catch (e) {
      print('Error parsing UserModel: $e');
      rethrow; // rethrow the error after logging it
    }
    return null;
  }
}



// import 'package:recce/configs/app_urls.dart';
// import 'package:recce/data/network/network_api_services.dart';
// import 'package:recce/models/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginRepository {
//   final _api = NetworkServicesApi();

//   //login method
//   Future<UserModel> loginApi(dynamic data) async {
//     final response = await _api.postApi(AppUrls.loginapi, data);
//     print('Response from login API: $response $data');
    
//     try {
//       // Print the response to verify its structure
//       print('Response JSON: $response');
      
//       // Deserialize JSON to UserModel
//       UserModel? userModel = UserModel.fromJson(response);
//       print('this is user $userModel');
      
    
//     // Store the user ID in SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userId', userModel.user.empId.toString());
     
    
 
      
//       return userModel;
//     } catch (e) {
//       print('Error parsing UserModel: $e');
//       rethrow; // rethrow the error after logging it
//     }
//   }
// }
