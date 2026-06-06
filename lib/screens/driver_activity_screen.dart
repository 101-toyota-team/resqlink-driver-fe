import 'package:flutter/material.dart';
import '../themes/app_typography.dart';
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
        "color": const Color(0xFF00AA13),
      },
      {
        "type": "Ambulans Gawat Darurat",
        "date": "14 Mei 2026, 09:30",
        "passenger": "Tono Sutrisno",
        "destination": "RS Pertamina Pusat",
        "status": "Selesai",
        "price": "Rp300.000",
        "color": const Color(0xFF00AA13),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: Text(
          "Aktivitas Tugas",
          style: AppTypography.h3.copyWith(color: const Color(0xFF1C1C1C), fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF0F0F0), height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          if (currentStep > 0) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Tugas Berjalan",
                style: AppTypography.title.copyWith(
                  color: const Color(0xFF1C1C1C),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DriverOngoingActivityCard(onOpenTaskRoute: onOpenTaskRoute),
            ),
            const SizedBox(height: 32),
          ],

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Riwayat Penugasan",
                  style: AppTypography.title.copyWith(
                    color: const Color(0xFF1C1C1C),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "Lihat Semua",
                  style: AppTypography.captionSmall.copyWith(
                    color: const Color(0xFF00AA13),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pastTasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: DriverPastTaskCard(data: pastTasks[index]),
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}