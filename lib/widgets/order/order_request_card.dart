import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class OrderRequestCard extends StatelessWidget {
  final VoidCallback onAccept;

  const OrderRequestCard({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emergency_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "TUGAS DARURAT BARU",
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
          
          // Header: Type & Fare
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ambulans Gawat Darurat", 
                      style: AppTypography.h3.copyWith(fontSize: 18)
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Kategori: Prioritas Tinggi",
                      style: AppTypography.caption.copyWith(color: AppColors.amber, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Rp300.000", 
                    style: AppTypography.h2.copyWith(color: AppColors.primary, fontSize: 22)
                  ),
                  Text(
                    "Estimasi Tarif",
                    style: AppTypography.captionSmall.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
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
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
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
                      "Terima Penugasan", 
                      style: AppTypography.button.copyWith(fontSize: 16)
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Abaikan Tugas",
                style: AppTypography.label.copyWith(color: AppColors.textGrey),
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
              _buildLocationItem("JEMPUT", "Jl. Margonda Raya No.124", AppColors.textDark),
              const SizedBox(height: 24),
              _buildLocationItem("TUJUAN", "RS Universitas Indonesia", AppColors.textDark),
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

