import 'package:flutter/material.dart';

class OrderRequestCard extends StatelessWidget {
  final VoidCallback onAccept;

  const OrderRequestCard({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFFCC9E60);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3DE),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        // Tambahkan border tipis di bagian atas agar sheet terlihat tegas memotong map
        border: Border.all(color: borderColor.withOpacity(0.4), width: 1.5),
        image: const DecorationImage(
          image: AssetImage('assets/images/medic_pattern.png'),
          fit: BoxFit.cover,
          opacity: 0.12,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Tipe Ambulans & Harga
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ambulans Gawat Darurat", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black87)
              ),
              Text(
                "Rp300.000", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.amber.shade900)
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: borderColor.withOpacity(0.4), thickness: 1.5),
          const SizedBox(height: 16),

          // Alur Lokasi Terintegrasi dengan Garis Penghubung Vertikal
          IntrinsicHeight(
            child: Row(
              children: [
                // Indikator Garis Alur di Sebelah Kiri
                Column(
                  children: [
                    const Icon(Icons.radio_button_checked, color: Colors.orange, size: 20),
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Colors.grey[400], // Garis vertikal penghubung lokasi
                      ),
                    ),
                    const Icon(Icons.location_on, color: Colors.red, size: 20),
                  ],
                ),
                const SizedBox(width: 14),
                
                // Konten Detail Alamat di Sebelah Kanan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titik Jemput
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("LOKASI JEMPUT PASIEN", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          SizedBox(height: 2),
                          Text("Jl. Margonda Raya No.124, Depok", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                        ],
                      ),
                      const Spacer(),
                      const SizedBox(height: 16), // Memberikan jarak antar alamat
                      
                      // Titik Tujuan
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("RUMAH SAKIT TUJUAN", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          SizedBox(height: 2),
                          Text("RS Universitas Indonesia (UI)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Tombol Terima Pesanan
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9E5C11),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text(
                "Terima Penugasan", 
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
              ),
            ),
          ),
        ],
      ),
    );
  }
}