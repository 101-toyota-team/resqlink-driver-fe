import 'package:flutter/material.dart';

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
            // 1. SEKSI TUGAS AKTIF (Hanya muncul jika currentStep > 0)
            if (currentStep > 0) ...[
              const Text(
                "Tugas Berjalan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              _buildOngoingActivityCard(context),
              const SizedBox(height: 24),
            ],

            // 2. SEKSI RIWAYAT TUGAS SELESAI
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
                return _buildPastTaskCard(pastTasks[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget Card untuk Tugas yang sedang Berjalan aktif
  Widget _buildOngoingActivityCard(BuildContext context) {
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
            _buildRouteInfo(Icons.person, "Pasien", "Joyney Dissy"),
            const SizedBox(height: 8),
            _buildRouteInfo(Icons.local_hospital, "Tujuan", "RS Universitas Indonesia"),
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
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF9E5C11)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget Card untuk Riwayat Masa Lalu
  Widget _buildPastTaskCard(Map<String, dynamic> data) {
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
            _buildRouteInfo(Icons.person_outline, "Mantan Pasien", data['passenger']),
            const SizedBox(height: 6),
            _buildRouteInfo(Icons.domain, "Destinasi", data['destination']),
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

  Widget _buildRouteInfo(IconData icon, String label, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87), overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}