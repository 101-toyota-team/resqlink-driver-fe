import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))
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
                Text(data['type'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: data['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data['status'],
                    style: TextStyle(color: data['color'], fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(data['date'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 12),
            ActivityRouteInfo(icon: Icons.person_outline, label: "Mantan Pasien", text: data['passenger']),
            const SizedBox(height: 6),
            ActivityRouteInfo(icon: Icons.domain, label: "Destinasi", text: data['destination']),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pendapatan Bersih", style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(data['price'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            )
          ],
        ),
      ),
    );
  }
}