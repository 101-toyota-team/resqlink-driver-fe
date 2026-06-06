import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class DriverHeroPerformanceCard extends StatelessWidget {
  const DriverHeroPerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _buildMetricItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label: "Pendapatan",
                  value: "Rp600.000",
                  color: const Color(0xFF00AA13),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: const Color(0xFFF0F0F0),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                _buildMetricItem(
                  icon: Icons.star_rounded,
                  label: "Rating",
                  value: "4.9",
                  color: const Color(0xFFEE8300),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: const Color(0xFFF0F0F0),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                _buildMetricItem(
                  icon: Icons.assignment_turned_in_rounded,
                  label: "Tugas",
                  value: "12",
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF757575)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Selalu periksa kelengkapan peralatan medis Anda",
                      style: AppTypography.captionSmall.copyWith(
                        color: const Color(0xFF757575),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    "Siaga",
                    style: AppTypography.label.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.captionSmall.copyWith(
                  color: const Color(0xFF757575),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.title.copyWith(
              fontSize: 15,
              color: const Color(0xFF1C1C1C),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}