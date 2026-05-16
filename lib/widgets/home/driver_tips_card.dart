import 'package:flutter/material.dart';

class DriverTipsCard extends StatelessWidget {
  const DriverTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9EE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF9E5C11).withOpacity(0.15), width: 1.2),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Color(0xFF9E5C11), size: 22),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sistem Otomatis Aktif", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                  SizedBox(height: 2),
                  Text(
                    "Pastikan status Anda tetap 'Siap Siaga' agar provider dapat langsung mengalokasikan darurat terdekat.",
                    style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}