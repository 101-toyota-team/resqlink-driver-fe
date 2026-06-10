import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'driver_service.dart';

class LocationService {
  static StreamSubscription<Position>? _positionStreamSubscription;
  static String? _currentBookingId;
  static DateTime? _lastUpdateTime;
  static const Duration _minUpdateInterval = Duration(seconds: 5);

  static Future<void> startTracking([String? bookingId]) async {
    debugPrint('DEBUG: Starting location tracking. Booking context: ${bookingId ?? "NONE"}');
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
      debugPrint('DEBUG: Location permission is currently DENIED. Requesting/Checking again...');
      try {
        // Jangan blokir flow jika requestPermission gagal karena tabrakan
        await Geolocator.requestPermission();
      } catch (e) {
        debugPrint('DEBUG: requestPermission failed (likely conflict): $e');
      }
      permission = await Geolocator.checkPermission();
    }
    
    if (permission == LocationPermission.deniedForever) {
      debugPrint('DEBUG: Location permissions are permanently denied. Cannot track.');
      return;
    }

    // Tetap lanjut meskipun status masih 'denied' (mungkin bug di geolocator saat tabrakan)
    debugPrint('DEBUG: Proceeding with tracking. Current status: $permission');

    // Ambil lokasi awal secara instan
    Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).then((pos) {
      debugPrint('DEBUG: Initial position fetched: ${pos.latitude}, ${pos.longitude}');
      _handlePositionUpdate(pos);
    }).catchError((e) {
      debugPrint('DEBUG: Error getting initial position: $e');
    });

    _positionStreamSubscription?.cancel();
    
    debugPrint('DEBUG: Starting position stream subscription...');
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0, // Set ke 0 agar sangat agresif di emulator
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
    final now = DateTime.now();
    // Gunakan interval 3 detik agar lebih sering terlihat di log
    if (_lastUpdateTime == null || now.difference(_lastUpdateTime!) >= const Duration(seconds: 3)) {
      debugPrint('DEBUG: Submission triggered for booking: ${_currentBookingId ?? "NONE"}');
      _lastUpdateTime = now;
      
      DriverService.updateLocation(
        bookingId: _currentBookingId,
        lat: position.latitude,
        lng: position.longitude,
        heading: position.heading,
        speed: position.speed,
        accuracy: position.accuracy,
      );
    }
  }
}
