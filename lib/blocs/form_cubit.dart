import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recce/models/survery/survey_model.dart';
import 'package:recce/repository/forms/load_form_repository.dart';
import 'package:recce/repository/forms/survey_form_repository.dart';
part 'form_state.dart';

class FormCubit extends Cubit<FormStates> {
  FormCubit() : super(FormInitial());

  Position? _currentLocation;
  final SurveyFormRepository _formRepository = SurveyFormRepository();
  final LoadFormRepository _loadFormRepository = LoadFormRepository();

  @override
  Future<void> close() {
    // Add any necessary cleanup code here
    return super.close();
  }

  void updateProgress(double progress) {
    if (!isClosed) {
      emit(FormUpLoading(progress: progress));
    }
  }

  void showLoader() {
    if (!isClosed) {
      emit(FormLoading());
    }
  }

  void handleError(String message) {
    if (!isClosed) {
      emit(FormError(message));
    }
  }

  Future<void> loadForm() async {
    List<Map<String, dynamic>> formData = [];

    if (isClosed) return; // Early exit if Cubit is closed

    // Emit loading state
    emit(FormLoading());

    try {
      // Fetch user location
      _currentLocation = await _getUserLocation();

      // Check if location is available
      if (_currentLocation == null) {
        if (!isClosed) emit(FormError("Unable to fetch location"));
        return;
      }

      // Emit current location state
      if (!isClosed) emit(CurrentLocation(_currentLocation!));

      // Fetch form data
      formData = await _loadFormRepository.newfetchFormDetails1();

      // Emit loaded form data state
      if (!isClosed) emit(FormLoaded(formData, _currentLocation));
    } catch (e) {
      // Emit error state with message
      if (!isClosed) emit(FormError("Failed to load data"));
          print('Error loading form data: $e'); // Print error details for debugging
    }
  }

  Future<Position?> _getUserLocation() async {
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      return null;
    }

    try {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );

      return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> _checkLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
      return status.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    return false;
  }

Future<void> uploadPhotosAndSubmitForm(Map<String, PhotoPickerData> photoPickerData, Map<String, dynamic> formValues, String? id) async {
  emit(FormUpLoading());
    try {
      int totalPhotos = photoPickerData.values.fold(
        0,
        (sum, photoPickerData) => sum + photoPickerData.photos.length,
      );
      int uploadedPhotos = 0;
      double progress = 0.0;

      for (var entry in photoPickerData.entries) {
        final photoPickerData = entry.value;
        final List<String> uploadedUrls = [];

        for (var photo in photoPickerData.photos) {
          final String? url = await _formRepository.uploadPhoto(photo);
          if (url != null) {
            uploadedUrls.add(url);
          }

          uploadedPhotos++;
          progress = uploadedPhotos / totalPhotos;
          print('progress is change $progress');
        }
         formValues[photoPickerData.id] = uploadedUrls;
         updateProgress(progress);

       
      }
     
      String submitJsonData = jsonEncode(formValues);
      submitForm(submitJsonData,id!);
    } catch (e) {
      emit(FormError('Failed to upload photos and submit form'));
      // context
      //     .read<FormCubit>()
      //     .handleError('Failed to upload photos and submit form');
    }
  }

  


  Future<void> submitForm(dynamic formData, String id) async {
    // Emit initial loading state
    emit(FormLoading());
    if (kDebugMode) {
      print("Submit form is called for $formData");
    }
    try {
      // Simulate progress

      final response =
          await _formRepository.submitSurveyForm(formData.toString(), id);
      if (kDebugMode) {
        print('This is response from survey form $response');
      }

      if (response.status == 1) {
        emit(FormSubmitted(response));
      } else {
        emit(FormError('Submission failed: ${response.message}'));
      }
    } catch (e) {
      emit(FormError('Exception occurred: $e'));
    }
  }

  Future<String> fetchSchool(String udisecode) async {
    // emit(FormLoading());
    if (kDebugMode) {
      print("fetch school is called for $udisecode");
    }
    try {
      final response =
          await _formRepository.fetchSchoolNames(udisecode.toString());
      if (kDebugMode) {
        //27251801204
        print('This is response from fetch school $response for $udisecode');
      }
      print(response);
      return response;
      // if (response.sta == 1) {
      //   emit(FormSubmitted(response));
      // } else {
      //   emit(FormError('Submission failed: ${response.message}'));
      // }
    } catch (e) {
      emit(FormError('Exception occurredasdfsadf: $e'));
      return 'School Not found';
    }
  }
}


class PhotoPickerData {
  final String id;
  List<File> photos;

  PhotoPickerData({required this.id, required this.photos});
}