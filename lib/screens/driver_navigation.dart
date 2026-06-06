import 'package:flutter/material.dart';
import 'package:resqlink_driver/screens/driver_main_screen.dart';
import 'package:resqlink_driver/screens/driver_home_screen.dart';
import 'package:resqlink_driver/screens/driver_activity_screen.dart';
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
  // 1: Di-assign Provider (Muncul Popup Tugas Aktif)
  // 2: Menuju Lokasi Pasien (Sedang di Jalan)
  // 3: Menuju Rumah Sakit (Sedang di Jalan)
  // 4: Selesaikan Pembayaran (QRIS)
  int _currentDriverStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTabIndex,
        children: [
          // TAB 0: BERANDA UTAMA
          DriverHomeScreen(
            currentStep: _currentDriverStep,
            onSimulateAssignment: () {
              _showNewAssignmentDialog();
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

  void _showNewAssignmentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: OrderRequestCard(
          onAccept: () {
            Navigator.pop(context); // Tutup Dialog
            setState(() {
              _currentDriverStep = 2; // Langsung ke tahap Menuju Lokasi Pasien
            });
            _navigateToMainRoute(); // Pindah ke halaman navigasi aktif
          },
        ),
      ),
    );
  }

  void _navigateToMainRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return DriverMainScreen(
                currentStep: _currentDriverStep,
                onStepChanged: (nextStep) {
                  // 1. Update State Utama di Parent Layout
                  setState(() {
                    _currentDriverStep = nextStep;
                  });
                  
                  // 2. Update State Lokal di dalam halaman yang di-push agar langsung berubah tampilannya
                  setModalState(() {});

                  // 3. LOGIKA SINKRONISASI: Jika tugas sudah diselesaikan (kembali ke 0), 
                  // tutup layar DriverMainScreen secara otomatis untuk kembali ke homepage bersih.
                  if (nextStep == 0) {
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
        _navigateToMainRoute(); // Jika diklik, otomatis langsung push masuk ke peta rute berjalan
      },
    );
  }
}