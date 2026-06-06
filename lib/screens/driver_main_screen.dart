import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_typography.dart';
import '../widgets/order/order_request_card.dart';
import '../../widgets/driver_navigation_sheet.dart';
import '../widgets/order/driver_qris_view.dart';
import '../widgets/order/mapbox_view.dart';

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
    // Tahap 4: Tampilan penuh QRIS
    if (currentStep == 4) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Pembayaran", style: AppTypography.title),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.black),
            onPressed: () => onStepChanged(0),
          ),
        ),
        body: DriverQrisView(
          onFinish: () => onStepChanged(0),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Map
          MapboxView(text: _getMapText(), currentStep: currentStep),
          
          // Custom Overlay Header (Gojek-like)
          if (currentStep != 1) 
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16, right: 16,
              child: _buildTripHeader(context),
            ),

          // Bottom Sheet Actions
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _buildBottomWidget(),
          ),
          
          // Back Button for Order Request
          if (currentStep == 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              child: _buildBackButton(context),
            ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1C1C1C)),
      ),
    );
  }

  Widget _buildTripHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF1C1C1C)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getAppBarTitle().toUpperCase(),
                  style: AppTypography.captionSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: const Color(0xFF757575),
                  ),
                ),
                Text(
                  _getTripSubTitle(),
                  style: AppTypography.title.copyWith(fontSize: 15, color: const Color(0xFF1C1C1C)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.more_horiz_rounded, color: Color(0xFF1C1C1C), size: 20),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (currentStep) {
      case 1: return "Penugasan Baru";
      case 2: return "Menuju Penjemputan";
      case 3: return "Menuju Rumah Sakit";
      case 4: return "Selesaikan Pembayaran";
      default: return "Trip Aktif";
    }
  }

  String _getTripSubTitle() {
    switch (currentStep) {
      case 2: return "Jl. Margonda Raya No.124";
      case 3: return "RS Universitas Indonesia (IGD)";
      default: return "Sedang dalam tugas...";
    }
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
          notes: "Sesak napas, butuh oksigen",
          buttonText: "Sampai di Penjemputan",
          buttonColor: AppColors.amber,
          onButtonPressed: () => onStepChanged(3),
          showMedicalForm: false,
        );
      case 3:
        return DriverNavigationSheet(
          passengerName: "Tujuan: RS UI (IGD)",
          notes: "Kondisi: Stabil dalam pantauan",
          buttonText: "Sampai di Rumah Sakit",
          buttonColor: AppColors.primary,
          onButtonPressed: () => onStepChanged(4),
          showMedicalForm: true,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

