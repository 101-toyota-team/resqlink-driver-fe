import 'package:flutter/material.dart';
import '../../themes/app_typography.dart';
import 'activity_route_info.dart';

class DriverPastTaskCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const DriverPastTaskCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01), 
            blurRadius: 8, 
            offset: const Offset(0, 4),
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
                  data['type'], 
                  style: AppTypography.title.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF1C1C1C),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  data['price'], 
                  style: AppTypography.title.copyWith(
                    fontSize: 15, 
                    color: const Color(0xFF1C1C1C),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['date'], 
                  style: AppTypography.captionSmall.copyWith(
                    color: const Color(0xFF757575),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (data['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    data['status'].toUpperCase(),
                    style: AppTypography.captionSmall.copyWith(
                      color: data['color'], 
                      fontWeight: FontWeight.w900,
                      fontSize: 9,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF0F0F0), height: 1),
            const SizedBox(height: 16),
            ActivityRouteInfo(
              icon: Icons.person_outline_rounded, 
              label: "Pasien", 
              text: data['passenger']
            ),
            const SizedBox(height: 10),
            ActivityRouteInfo(
              icon: Icons.local_hospital_outlined, 
              label: "Tujuan", 
              text: data['destination']
            ),
          ],
        ),
      ),
    );
  }
}

