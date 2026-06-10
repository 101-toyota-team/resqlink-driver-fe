import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'driver_service.dart';

class LocationService {
  static StreamSubscription<Position>? _positionStreamSubscription;
  static String? _currentBookingId;
  static DateTime? _lastUpdateTime;
  static bool _isFirstUpdate = true;
  
  // Interval minimum antar pengiriman ke backend (3 detik untuk testing agar responsif)
  static const Duration _minUpdateInterval = Duration(seconds: 3);

  // Dipanggil saat awal aplikasi dibuka untuk memicu dialog izin lebih awal
  static Future<void> preRequestPermissions() async {
    try {
      debugPrint('DEBUG: [LocationService] Pre-requesting permissions...');
      await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Memicu dialog sistem secara asinkron
        Geolocator.requestPermission();
      }
      debugPrint('DEBUG: [LocationService] Pre-request check DONE');
    } catch (e) {
      debugPrint('DEBUG: [LocationService] Pre-request error: $e');
    }
  }

  static Future<void> startTracking([String? bookingId]) async {
    debugPrint('DEBUG: [LocationService] Starting tracking for booking: ${bookingId ?? "NONE"}');
    _currentBookingId = bookingId;
    _isFirstUpdate = true; // Reset flag saat tracking baru dimulai
    _lastUpdateTime = null; // Reset last update time
    
    // Jangan biarkan pengecekan izin memblokir flow utama
    _initializeTrackingAggressively();
  }

  static Future<void> _initializeTrackingAggressively() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('DEBUG: [LocationService] GPS Hardware is DISABLED');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('DEBUG: [LocationService] Current Permission Status: $permission');

      if (permission == LocationPermission.denied) {
        debugPrint('DEBUG: [LocationService] Permission DENIED. Triggering NON-BLOCKING request...');
        Geolocator.requestPermission().then((p) {
          debugPrint('DEBUG: [LocationService] Async Permission Result: $p');
        }).catchError((e) {
          debugPrint('DEBUG: [LocationService] Async Permission Error: $e');
        });
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('DEBUG: [LocationService] Permission PERMANENTLY DENIED');
        return;
      }

      // TETAP LANJUT: Walaupun status 'denied', kita coba panggil API Geolocator.
      debugPrint('DEBUG: [LocationService] Attempting to fetch initial position...');
      Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      ).then((pos) {
        debugPrint('DEBUG: [LocationService] Initial position FETCH SUCCESS: ${pos.latitude}, ${pos.longitude}');
        _handlePositionUpdate(pos);
      }).catchError((e) {
        debugPrint('DEBUG: [LocationService] Initial position FETCH FAILED: $e');
      });

      // Siapkan Stream
      _positionStreamSubscription?.cancel();
      
      debugPrint('DEBUG: [LocationService] Subscribing to continuous position stream...');
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0, 
        ),
      ).listen(
        (Position position) {
          _handlePositionUpdate(position);
        },
        onError: (e) {
          debugPrint('DEBUG: [LocationService] Stream ERROR: $e');
        }
      );

    } catch (e) {
      debugPrint('DEBUG: [LocationService] CRITICAL INIT ERROR: $e');
    }
  }

  static void stopTracking() {
    debugPrint('DEBUG: [LocationService] Stopping tracking');
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _currentBookingId = null;
    _lastUpdateTime = null;
    _isFirstUpdate = true;
  }

  static void _handlePositionUpdate(Position position) {
    final now = DateTime.now();
    
    // Throttle: hanya kirim jika sudah melewati interval minimum
    if (_lastUpdateTime == null || now.difference(_lastUpdateTime!) >= _minUpdateInterval) {
      
      // Jika ini update pertama, berikan delay 2 detik agar status update (en_route) di backend selesai dulu
      if (_isFirstUpdate) {
        _isFirstUpdate = false;
        debugPrint('DEBUG: [LocationService] First update detected. Waiting 2s before submission to ensure backend status sync...');
        Future.delayed(const Duration(seconds: 2), () {
          _submitLocation(position);
        });
      } else {
        _submitLocation(position);
      }
      
      _lastUpdateTime = now;
    } else {
      debugPrint('DEBUG: [LocationService] Skipping location update (throttled)');
    }
  }

  static void _submitLocation(Position position) {
    if (_currentBookingId == null) {
      debugPrint('DEBUG: [LocationService] No active booking, skipping location submission');
      return;
    }

    debugPrint('DEBUG: [LocationService] SUBMITTING location to backend (Booking: $_currentBookingId)');
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