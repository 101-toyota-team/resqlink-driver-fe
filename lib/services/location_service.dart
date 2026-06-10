import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'driver_service.dart';

class LocationService {
  static StreamSubscription<Position>? _positionStreamSubscription;
  static String? _currentBookingId;
  static DateTime? _lastUpdateTime;
  static const Duration _minUpdateInterval = Duration(seconds: 5);

  static Future<void> startTracking(String bookingId) async {
    _currentBookingId = bookingId;
    
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    _positionStreamSubscription?.cancel();
    
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _handlePositionUpdate(position);
    });
  }

  static void stopTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _currentBookingId = null;
  }

  static void _handlePositionUpdate(Position position) {
    if (_currentBookingId == null) return;

    final now = DateTime.now();
    if (_lastUpdateTime == null || now.difference(_lastUpdateTime!) >= _minUpdateInterval) {
      _lastUpdateTime = now;
      
      DriverService.updateLocation(
        bookingId: _currentBookingId!,
        lat: position.latitude,
        lng: position.longitude,
        heading: position.heading,
        speed: position.speed,
        accuracy: position.accuracy,
      );
    }
  }
}
