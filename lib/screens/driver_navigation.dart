import 'package:flutter/material.dart';
import 'package:resqlink_driver/models/booking.dart';
import 'package:resqlink_driver/screens/driver_main_screen.dart';
import 'package:resqlink_driver/screens/driver_home_screen.dart';
import 'package:resqlink_driver/screens/driver_activity_screen.dart';
import 'package:resqlink_driver/services/driver_service.dart';
import 'package:resqlink_driver/services/location_service.dart';
import '../../widgets/driver_bottom_nav.dart'; 
import '../../widgets/order/order_request_card.dart';


class DriverNavigation extends StatefulWidget {
  const DriverNavigation({super.key});

  @override
  State<DriverNavigation> createState() => _DriverNavigationState();
}

class _DriverNavigationState extends State<DriverNavigation> {
  int _selectedTabIndex = 0;

  // GLOBAL STATE UNTUK MENGONTROL ALUR TUGAS
  // 0: Standby Kosong (Tidak ada tugas)
  // 2: Menuju Lokasi Pasien (en_route)
  // 3: Menuju Rumah Sakit (to_hospital)
  // 4: Selesaikan Pembayaran (QRIS)
  int _currentDriverStep = 0;
  Booking? _activeBooking;

  void _onStepChanged(int nextStep) {
    setState(() {
      _currentDriverStep = nextStep;
    });

    if (_activeBooking != null) {
      String status;
      switch (nextStep) {
        case 2: status = 'en_route'; break;
        case 3: 
          // Set ke 'arrived' dulu, lalu ke 'to_hospital'
          DriverService.updateBookingStatus(_activeBooking!.id, 'arrived')
              .catchError((e) => debugPrint('Error update status arrived: $e'));
          status = 'to_hospital'; 
          break;
        case 0: status = 'completed'; break;
        default: return;
      }
      
      DriverService.updateBookingStatus(_activeBooking!.id, status)
          .catchError((e) => debugPrint('Error update status: $e'));

      if (nextStep == 2 || nextStep == 3) {
        LocationService.startTracking(_activeBooking!.id);
      } else {
        LocationService.stopTracking();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTabIndex,
        children: [
          // TAB 0: BERANDA UTAMA
          DriverHomeScreen(
            currentStep: _currentDriverStep,
            onStartAssignment: (booking) {
              setState(() => _activeBooking = booking);
              _onStepChanged(2); // Set status ke en_route
              _navigateToMainRoute();
            },
            onOpenTaskRoute: () {
              _navigateToMainRoute();
            },
          ),

          // TAB 1: AKTIVITAS / RIWAYAT
          _buildActivityTab(),
        ],
      ),
      bottomNavigationBar: DriverBottomNav(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
      ),
    );
  }

  void _navigateToMainRoute() {
    if (_activeBooking == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return DriverMainScreen(
                currentStep: _currentDriverStep,
                booking: _activeBooking!,
                onStepChanged: (nextStep) {
                  _onStepChanged(nextStep);
                  setModalState(() {});
                  if (nextStep == 0) {
                    setState(() => _activeBooking = null);
                    Navigator.pop(context);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActivityTab() {
    return DriverActivityScreen(
      currentStep: _currentDriverStep,
      onOpenTaskRoute: () {
        _navigateToMainRoute();
      },
    );
  }
}