import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationCubit extends Cubit<Position?> {
  LocationCubit() : super(null);

  Future<void> getLocation() async {
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      emit(null);
      return;
    }

    try {
      // Use LocationSettings with platform-specific settings
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0, // You can set this to filter out updates too close together
      );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      emit(position);
    } catch (e) {
      emit(null); // Handle error state
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
}
