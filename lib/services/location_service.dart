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
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      debugPrint('DEBUG: Location permission denied, requesting...');
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('DEBUG: Location permission denied again.');
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      debugPrint('DEBUG: Location permissions are permanently denied.');
      return Future.error('Location permissions are permanently denied');
    }

    debugPrint('DEBUG: Location permissions granted. Fetching initial position...');

    // Ambil lokasi awal secara instan dan submit ke backend
    try {
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      debugPrint('DEBUG: Initial position fetched: ${initialPosition.latitude}, ${initialPosition.longitude}');
      _handlePositionUpdate(initialPosition);
    } catch (e) {
      debugPrint('DEBUG: Error getting initial position: $e');
    }

    _positionStreamSubscription?.cancel();
    
    debugPrint('DEBUG: Starting position stream subscription...');
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _handlePositionUpdate(position);
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
