import 'package:flutter/material.dart';

class DriverQrisView extends StatelessWidget {
  final VoidCallback onFinish;

  const DriverQrisView({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("QRIS Pembayaran", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Total Tagihan Pasien", style: TextStyle(color: Colors.grey)),
              const Text("Rp300.000", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black)),
              const SizedBox(height: 20),
              Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: const Icon(Icons.qr_code_2, size: 140, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              const Text("Silakan tunjukkan QRIS ini kepada pihak keluarga pasien.", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: onFinish,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF9E5C11), width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Transaksi Selesai", style: TextStyle(color: Color(0xFF9E5C11), fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}