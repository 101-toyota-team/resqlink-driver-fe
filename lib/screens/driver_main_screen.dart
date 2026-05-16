import 'package:flutter/material.dart';
import '../widgets/order/order_request_card.dart';
import '../../widgets/driver_navigation_sheet.dart';
import '../widgets/order/driver_qris_view.dart';
import '../../widgets/order/driver_map_placeholder.dart';

class DriverMainScreen extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int> onStepChanged;

  const DriverMainScreen({
    super.key,
    required this.currentStep,
    required this.onStepChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DE),
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(), 
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: _buildCurrentStepView(context),
    );
  }

  String _getAppBarTitle() {
    switch (currentStep) {
      case 1: return "Penugasan Baru";
      case 2: return "Navigasi: Penjemputan";
      case 3: return "Navigasi: Rumah Sakit";
      case 4: return "Selesaikan Pembayaran";
      default: return "Penugasan Aktif";
    }
  }

  Widget _buildCurrentStepView(BuildContext context) {
    // Tahap 4: Tampilan penuh QRIS tanpa komponen peta di atasnya
    if (currentStep == 4) {
      return DriverQrisView(
        onFinish: () {
          onStepChanged(0); // Set status kembali standby kosong (0)
        },
      );
    }

    // Tahap 1, 2, dan 3: Tampilan Peta + Bottom Sheet Aksi Supir
    return Stack(
      children: [
        // MEMANGGIL WIDGET MAP YANG SUDAH DIREFACTOR
        DriverMapPlaceholder(text: _getMapText()),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: _buildBottomWidget(),
        ),
      ],
    );
  }

  String _getMapText() {
    switch (currentStep) {
      case 1: return "Mencari rute penugasan...";
      case 2: return "Rute: Menuju Lokasi Pasien 📍";
      case 3: return "Rute: Menuju RS Universitas Indonesia 🏥";
      default: return "Maps";
    }
  }

  Widget _buildBottomWidget() {
    switch (currentStep) {
      case 1:
        return OrderRequestCard(
          onAccept: () => onStepChanged(2),
        );
      case 2:
        return DriverNavigationSheet(
          passengerName: "Joyney Dissy",
          notes: "Sesak napas, butuh tabung oksigen tambahan.",
          buttonText: "Sampai di Tempat Jemput",
          buttonColor: Colors.orange.shade800,
          onButtonPressed: () => onStepChanged(3),
        );
      case 3:
        return DriverNavigationSheet(
          passengerName: "Tujuan: RS UI (IGD)",
          notes: "Kondisi: Stabil dalam pantauan alat medis.",
          buttonText: "Sampai di Rumah Sakit Tujuan",
          buttonColor: Colors.green.shade700,
          onButtonPressed: () => onStepChanged(4),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}