import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import '../../models/booking.dart';

class OrderRequestCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onAccept;

  const OrderRequestCard({
    super.key, 
    required this.booking,
    required this.onAccept
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New Task Badge
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emergency_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "PENUGASAN AKTIF",
                    style: AppTypography.captionSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Header: Type
          Text(
            booking.patientCondition, 
            style: AppTypography.h3.copyWith(fontSize: 20),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "Layanan: ${booking.bookingType.toUpperCase()}",
            style: AppTypography.caption.copyWith(color: AppColors.textGrey, fontWeight: FontWeight.w700),
          ),
          
          const SizedBox(height: 24),
          Container(height: 1, color: AppColors.divider.withValues(alpha: 0.5)),
          const SizedBox(height: 24),

          // Route Info
          _buildRouteSection(),

          const SizedBox(height: 32),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Mulai Jalankan Tugas", 
                      style: AppTypography.button.copyWith(fontSize: 16)
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const Icon(Icons.radio_button_checked_rounded, color: AppColors.amber, size: 20),
            Container(
              width: 2,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationItem("JEMPUT", booking.pickupAddress, AppColors.textDark),
              const SizedBox(height: 24),
              _buildLocationItem("TUJUAN", booking.destinationAddress, AppColors.textDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationItem(String label, String address, Color addressColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.captionSmall.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textGrey.withValues(alpha: 0.6),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w700,
            color: addressColor,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

