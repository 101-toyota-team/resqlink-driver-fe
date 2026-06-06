import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class DriverQrisView extends StatelessWidget {
  final VoidCallback onFinish;

  const DriverQrisView({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.secondary,
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08), 
                  blurRadius: 24, 
                  offset: const Offset(0, 12),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "QRIS Pembayaran", 
                  style: AppTypography.h3
                ),
                const SizedBox(height: 12),
                Text(
                  "Total Tagihan Pasien", 
                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp300.000", 
                  style: AppTypography.h1.copyWith(color: AppColors.primary, fontSize: 32)
                ),
                const SizedBox(height: 32),
                Container(
                  width: 240, 
                  height: 240,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.divider, width: 2),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.qr_code_2_rounded, size: 160, color: AppColors.textDark),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Silakan tunjukkan QRIS ini kepada pihak keluarga pasien atau rumah sakit.", 
                  textAlign: TextAlign.center, 
                  style: AppTypography.body.copyWith(fontSize: 12, height: 1.5)
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: onFinish,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                    ),
                    child: Text(
                      "Transaksi Selesai", 
                      style: AppTypography.button.copyWith(color: AppColors.primary)
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
