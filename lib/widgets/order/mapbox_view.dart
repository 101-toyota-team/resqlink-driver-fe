import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../themes/app_colors.dart';

class MapboxView extends StatefulWidget {
  final String text;
  final int currentStep;

  const MapboxView({
    super.key,
    required this.text,
    this.currentStep = 0,
  });

  @override
  State<MapboxView> createState() => _MapboxViewState();
}

class _MapboxViewState extends State<MapboxView> {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  PolylineAnnotationManager? _polylineAnnotationManager;
  
  PointAnnotation? _driverAnnotation;
  PolylineAnnotation? _routePolyline;
  PolylineAnnotation? _remainingPolyline;

  StreamSubscription<geo.Position>? _positionStream;
  geo.Position? _currentPosition;

  // Mock Coordinates
  final Position _pickupPosition = Position(106.8244, -6.1820); // Near Sarinah
  final Position _hospitalPosition = Position(106.8272, -6.1751); // Monas area

  @override
  void initState() {
    super.initState();
    String accessToken = dotenv.env['MAPBOX_TOKEN'] ?? "";
    MapboxOptions.setAccessToken(accessToken);
    _checkLocationPermission();
  }

  @override
  void didUpdateWidget(covariant MapboxView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _updateMapState();
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool serviceEnabled;
      geo.LocationPermission permission;

      serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) return;
      }
      
      if (permission == geo.LocationPermission.deniedForever) return;

      // Ambil lokasi awal secara instan
      final initialPosition = await geo.Geolocator.getCurrentPosition(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
        ),
      );
      
      if (mounted) {
        setState(() {
          _currentPosition = initialPosition;
        });
        _updateMapState();
      }

      _startLocationTracking();
    } catch (e) {
      debugPrint("Error checking location: $e");
    }
  }

  void _startLocationTracking() {
    try {
      _positionStream = geo.Geolocator.getPositionStream(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.bestForNavigation,
          distanceFilter: 2, // Lebih sensitif (2 meter)
        ),
      ).listen((geo.Position position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });
          _updateMapState();
        }
      });
    } catch (e) {
      debugPrint("Error starting location tracking: $e");
    }
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    _mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    _mapboxMap?.compass.updateSettings(CompassSettings(enabled: false));

    // Enable Mapbox standard location component (optional dot)
    await mapboxMap.location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
    ));

    _pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
    _polylineAnnotationManager = await mapboxMap.annotations.createPolylineAnnotationManager();
    
    await _registerIcons(mapboxMap);
    _updateMapState();
  }

  Future<void> _registerIcons(MapboxMap targetMap) async {
    final iconsToDraw = [
      {"id": "driver-icon", "color": AppColors.primary, "icon": Icons.airport_shuttle_rounded},
      {"id": "patient-icon", "color": AppColors.ambulanceMedis, "icon": Icons.person_pin_circle_rounded},
      {"id": "hospital-icon", "color": AppColors.ambulanceSosial, "icon": Icons.local_hospital_rounded}
    ];

    for (var target in iconsToDraw) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 100, 100));
      
      canvas.drawCircle(const Offset(50, 50), 45, Paint()..color = Colors.white);
      canvas.drawCircle(
        const Offset(50, 50), 
        45, 
        Paint()..color = target["color"] as Color..style = PaintingStyle.stroke..strokeWidth = 8
      );

      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: String.fromCharCode((target["icon"] as IconData).codePoint),
        style: TextStyle(
          fontSize: 55, 
          fontFamily: (target["icon"] as IconData).fontFamily, 
          color: target["color"] as Color
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(50 - textPainter.width / 2, 50 - textPainter.height / 2));

      final img = await recorder.endRecording().toImage(100, 100);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        await targetMap.style.addStyleImage(
          target["id"] as String, 
          1.0, 
          MbxImage(width: 100, height: 100, data: byteData.buffer.asUint8List()), 
          false, [], [], null
        );
      }
    }
  }

  bool _hasInitialCenter = false;

  void _updateMapState() async {
    if (_mapboxMap == null || _currentPosition == null) return;

    final driverPos = Position(_currentPosition!.longitude, _currentPosition!.latitude);
    
    // 1. Update Markers
    if (_pointAnnotationManager != null) {
      await _pointAnnotationManager?.deleteAll();
      _driverAnnotation = null;

      // Driver
      _driverAnnotation = await _pointAnnotationManager?.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: driverPos),
          iconImage: "driver-icon",
          iconSize: 0.4,
        ),
      );
      
      // Patient/Pickup
      await _pointAnnotationManager?.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: _pickupPosition),
          iconImage: "patient-icon",
          iconSize: 0.35,
        ),
      );

      // Hospital
      await _pointAnnotationManager?.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: _hospitalPosition),
          iconImage: "hospital-icon",
          iconSize: 0.35,
        ),
      );
    }

    // 2. Update Polylines
    if (_polylineAnnotationManager != null) {
      if (_routePolyline != null) await _polylineAnnotationManager?.delete(_routePolyline!);
      if (_remainingPolyline != null) await _polylineAnnotationManager?.delete(_remainingPolyline!);

      if (widget.currentStep == 2) {
        // En route to Patient
        _routePolyline = await _polylineAnnotationManager?.create(
          PolylineAnnotationOptions(
            geometry: LineString(coordinates: [driverPos, _pickupPosition]),
            lineColor: AppColors.primary.toARGB32(),
            lineWidth: 6.0,
          ),
        );
        _remainingPolyline = await _polylineAnnotationManager?.create(
          PolylineAnnotationOptions(
            geometry: LineString(coordinates: [_pickupPosition, _hospitalPosition]),
            lineColor: AppColors.primary.withValues(alpha: 0.3).toARGB32(),
            lineWidth: 6.0,
          ),
        );
      } else if (widget.currentStep == 3) {
        // En route to Hospital
        _routePolyline = await _polylineAnnotationManager?.create(
          PolylineAnnotationOptions(
            geometry: LineString(coordinates: [driverPos, _hospitalPosition]),
            lineColor: AppColors.primary.toARGB32(),
            lineWidth: 6.0,
          ),
        );
      }
    }

    // 3. Fly to Driver Position (Hanya jika belum center atau sedang navigasi)
    if (!_hasInitialCenter || widget.currentStep >= 2) {
      _mapboxMap?.flyTo(
        CameraOptions(
          center: Point(coordinates: driverPos), 
          zoom: 15.5
        ),
        MapAnimationOptions(duration: 1000),
      );
      _hasInitialCenter = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.secondary,
      child: Stack(
        children: [
          MapWidget(
            key: const ValueKey("driverMap"),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _onMapCreated,
            viewport: CameraViewportState(
              center: Point(coordinates: Position(106.8272, -6.1751)), // Default: Jakarta
              zoom: 12.0,
            ),
          ),
          if (_currentPosition == null)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}
