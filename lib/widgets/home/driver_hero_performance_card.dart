import 'package:flutter/material.dart';

class DriverHeroPerformanceCard extends StatelessWidget {
  const DriverHeroPerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9E5C11).withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/resqlink-banner.png',
              width: double.infinity,
              height: 165,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Container(color: Colors.white.withOpacity(0.4)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pendapatan Hari Ini", 
                    style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.2)
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Rp600.000", 
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF9E5C11), letterSpacing: -0.5)
                  ),
                  const SizedBox(height: 14),
                  Container(width: double.infinity, height: 1.2, color: const Color(0xFF9E5C11).withOpacity(0.15)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildHeroMetricItem(Icons.assignment_turned_in_rounded, "Total Tugas", "2", Colors.orange.shade900),
                      Container(
                        width: 1.5, height: 24, 
                        color: const Color(0xFF9E5C11).withOpacity(0.2), 
                        margin: const EdgeInsets.symmetric(horizontal: 20)
                      ),
                      _buildHeroMetricItem(Icons.star_rounded, "Rating Driver", "4.9", Colors.amber.shade900),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroMetricItem(IconData icon, String label, String value, Color colorIcon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colorIcon),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.w600)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}