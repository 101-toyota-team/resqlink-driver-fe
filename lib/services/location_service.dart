import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'driver_service.dart';

class LocationService {
  static StreamSubscription<Position>? _positionStreamSubscription;
  static String? _currentBookingId;
  static DateTime? _lastUpdateTime;
  static const Duration _minUpdateInterval = Duration(seconds: 5);

  static Future<void> startTracking(String bookingId) async {
    debugPrint('DEBUG: Starting location tracking for booking: $bookingId');
    _currentBookingId = bookingId;
    
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('DEBUG: Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      debugPrint('DEBUG: Location permission is currently DENIED. Requesting now...');
      try {
        permission = await Geolocator.requestPermission();
      } catch (e) {
        debugPrint('DEBUG: Exception while requesting permission: $e');
        // Tetap coba cek permission lagi, siapa tahu sudah diberikan via dialog sistem lain
        permission = await Geolocator.checkPermission();
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      debugPrint('DEBUG: Location permissions are permanently denied.');
      return;
    }

    if (permission == LocationPermission.denied) {
      debugPrint('DEBUG: Location permission is still denied after request.');
      return;
    }

    debugPrint('DEBUG: Location permission is OK ($permission). Fetching initial position...');

    // Ambil lokasi awal secara instan dan submit ke backend
    try {
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      debugPrint('DEBUG: Initial position SUCCESS: ${initialPosition.latitude}, ${initialPosition.longitude}');
      _handlePositionUpdate(initialPosition);
    } catch (e) {
      debugPrint('DEBUG: Error getting initial position: $e');
    }

    _positionStreamSubscription?.cancel();
    
    debugPrint('DEBUG: Starting continuous position stream...');
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _handlePositionUpdate(position);
    }, onError: (e) {
      debugPrint('DEBUG: Position stream ERROR: $e');
    });
  }

  static void stopTracking() {
    debugPrint('DEBUG: Stopping location tracking');
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _currentBookingId = null;
  }

  static void _handlePositionUpdate(Position position) {
    if (_currentBookingId == null) return;

    final now = DateTime.now();
    if (_lastUpdateTime == null || now.difference(_lastUpdateTime!) >= _minUpdateInterval) {
      debugPrint('DEBUG: Triggering location submission to backend for booking $_currentBookingId');
      _lastUpdateTime = now;
      
      DriverService.updateLocation(
        bookingId: _currentBookingId!,
        lat: position.latitude,
        lng: position.longitude,
        heading: position.heading,
        speed: position.speed,
        accuracy: position.accuracy,
      );
    } else {
      debugPrint('DEBUG: Location update skipped (interval < 5s)');
    }
  }
}
