import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';
import 'activity_route_info.dart';

class DriverOngoingActivityCard extends StatelessWidget {
  final VoidCallback onOpenTaskRoute;

  const DriverOngoingActivityCard({
    super.key,
    required this.onOpenTaskRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06), 
            blurRadius: 16, 
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ambulans Gawat Darurat",
                  style: AppTypography.title.copyWith(fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Dalam Tugas",
                    style: AppTypography.captionSmall.copyWith(
                      color: Colors.blue.shade700, 
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const ActivityRouteInfo(icon: Icons.person_rounded, label: "Pasien", text: "Joyney Dissy"),
            const SizedBox(height: 10),
            const ActivityRouteInfo(icon: Icons.local_hospital_rounded, label: "Tujuan", text: "RS Universitas Indonesia"),
            const SizedBox(height: 20),
            Container(height: 1, color: AppColors.divider),
            const SizedBox(height: 16),
            InkWell(
              onTap: onOpenTaskRoute,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Lihat Detail Navigasi",
                      style: AppTypography.label.copyWith(
                        color: AppColors.primary, 
                        fontWeight: FontWeight.w800, 
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
