import 'package:flutter/material.dart';
import '../../widgets/activity/driver_ongoing_activity_card.dart';
import '../../widgets/activity/driver_past_task_card.dart';

class DriverActivityScreen extends StatelessWidget {
  final int currentStep;
  final VoidCallback onOpenTaskRoute;

  const DriverActivityScreen({
    super.key,
    required this.currentStep,
    required this.onOpenTaskRoute,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy Data Riwayat Penugasan Ambulans yang Sudah Selesai
    final List<Map<String, dynamic>> pastTasks = [
      {
        "type": "Ambulans Gawat Darurat",
        "date": "16 Mei 2026, 14:10",
        "passenger": "Amelia Danasyandra",
        "destination": "RS Fatmawati",
        "status": "Selesai",
        "price": "Rp300.000",
        "color": Colors.green,
      },
      {
        "type": "Ambulans Gawat Darurat",
        "date": "14 Mei 2026, 09:30",
        "passenger": "Tono Sutrisno",
        "destination": "RS Pertamina Pusat",
        "status": "Selesai",
        "price": "Rp300.000",
        "color": Colors.green,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Aktivitas Tugas",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF3DE), // Latar krem khas ResQLink
          image: DecorationImage(
            image: AssetImage('assets/images/medic_pattern.png'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (currentStep > 0) ...[
              const Text(
                "Tugas Berjalan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              DriverOngoingActivityCard(onOpenTaskRoute: onOpenTaskRoute),
              const SizedBox(height: 24),
            ],

            const Text(
              "Riwayat Penugasan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pastTasks.length,
              itemBuilder: (context, index) {
                return DriverPastTaskCard(data: pastTasks[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}