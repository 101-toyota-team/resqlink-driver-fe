import 'package:flutter/material.dart';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF9E5C11), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Ambulans Gawat Darurat",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Dalam Tugas",
                    style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const ActivityRouteInfo(icon: Icons.person, label: "Pasien", text: "Joyney Dissy"),
            const SizedBox(height: 8),
            const ActivityRouteInfo(icon: Icons.local_hospital, label: "Tujuan", text: "RS Universitas Indonesia"),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            InkWell(
              onTap: onOpenTaskRoute,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "Lihat Detail Navigasi",
                    style: TextStyle(color: Color(0xFF9E5C11), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF9E5C11)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}