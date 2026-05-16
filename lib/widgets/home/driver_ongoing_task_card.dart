import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class DriverOngoingTaskCard extends StatelessWidget {
  final int currentStep;
  final VoidCallback onOpenTaskRoute;

  const DriverOngoingTaskCard({
    super.key,
    required this.currentStep,
    required this.onOpenTaskRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF9E5C11).withOpacity(0.3), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/resqlink-banner.png',
                width: double.infinity,
                height: 90,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 12, left: 16,
                child: _buildMapPinBadge(Icons.location_on, "Penjemputan", Colors.orange.shade800),
              ),
              Positioned(
                bottom: 12, right: 16,
                child: _buildMapPinBadge(Icons.local_hospital, "Tujuan", Colors.green.shade700),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_rounded, color: Colors.red, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "TUGAS DARURAT SEDANG BERJALAN",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.red.shade800, letterSpacing: 0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTaskDetailColumn(
                        icon: Icons.person_rounded,
                        title: "Pasien",
                        mainText: "Joyney Dissy",
                        subText: "Kontak: +62 857-1100",
                        colorTheme: const Color(0xFF9E5C11),
                      ),
                    ),
                    Container(width: 1, height: 45, color: Colors.grey.shade200, margin: const EdgeInsets.symmetric(horizontal: 12)),
                    Expanded(
                      child: _buildTaskDetailColumn(
                        icon: Icons.local_hospital_rounded,
                        title: "Rumah Sakit Tujuan",
                        mainText: "RS Universitas Indonesia",
                        subText: "Usia: 30 | Darah: O-",
                        colorTheme: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFFFFF9EE), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.access_time_filled_rounded, size: 16, color: Color(0xFF9E5C11)),
                          SizedBox(width: 6),
                          Text("Waktu Penugasan", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black54)),
                        ],
                      ),
                      const Text("12:35 Menit Berlalu", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9E5C11))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Status Alur Penugasan", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.black54)),
                const SizedBox(height: 8),
                _buildDriverStepTracker(),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.gradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF9E5C11).withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: onOpenTaskRoute,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Buka Peta & Navigasi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPinBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildTaskDetailColumn({required IconData icon, required String title, required String mainText, required String subText, required Color colorTheme}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: colorTheme),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(mainText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87), overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(subText, style: const TextStyle(fontSize: 10.5, color: Colors.black54), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverStepTracker() {
    final steps = ["Diterima", "Jemput", "Ke RS", "Selesai"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (index) {
        int stepNum = index + 1;
        bool isDone = currentStep > stepNum;
        bool isActive = currentStep == stepNum;

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? const Color(0xFF9E5C11) : (isActive ? Colors.amber.shade700 : Colors.grey.shade200),
                      border: isActive ? Border.all(color: const Color(0xFF9E5C11), width: 1.5) : null,
                    ),
                    child: Center(
                      child: isDone 
                          ? const Icon(Icons.check, size: 11, color: Colors.white)
                          : Text("$stepNum", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.black54)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(steps[index], style: TextStyle(fontSize: 9, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? const Color(0xFF9E5C11) : Colors.black54)),
                ],
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 14),
                    color: currentStep > stepNum ? const Color(0xFF9E5C11) : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}