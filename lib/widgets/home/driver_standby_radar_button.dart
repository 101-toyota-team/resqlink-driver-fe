import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class DriverStandbyRadarButton extends StatelessWidget {
  final bool isStandby;
  final VoidCallback onSimulateAssignment;

  const DriverStandbyRadarButton({
    super.key,
    required this.isStandby,
    required this.onSimulateAssignment,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isStandby) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ubah status ke SIAP SIAGA terlebih dahulu!")),
          );
          return;
        }
        onSimulateAssignment();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140, height: 140, 
            decoration: BoxDecoration(
              shape: BoxShape.circle, 
              color: isStandby ? const Color(0xFF9E5C11).withOpacity(0.08) : Colors.grey.withOpacity(0.04)
            )
          ),
          Container(
            width: 95, height: 95,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.gradient,
              boxShadow: [
                BoxShadow(color: const Color(0xFF9E5C11).withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isStandby ? Icons.gpp_good_rounded : Icons.power_settings_new_rounded, color: Colors.white, size: 28),
                const SizedBox(height: 4),
                Text(
                  isStandby ? "Menunggu\nTugas" : "Mulai Aktif",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, height: 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}