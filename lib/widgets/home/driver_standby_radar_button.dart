import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class DriverStandbyRadarButton extends StatefulWidget {
  final bool isStandby;
  final VoidCallback onSimulateAssignment;

  const DriverStandbyRadarButton({
    super.key,
    required this.isStandby,
    required this.onSimulateAssignment,
  });

  @override
  State<DriverStandbyRadarButton> createState() => _DriverStandbyRadarButtonState();
}

class _DriverStandbyRadarButtonState extends State<DriverStandbyRadarButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isStandby) {
          widget.onSimulateAssignment();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Aktifkan status 'Siap Siaga' untuk menerima tugas",
                style: AppTypography.bodyWhite,
              ),
              backgroundColor: AppColors.textDark,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.all(20),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.isStandby ? AppColors.white : AppColors.cardBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: widget.isStandby ? AppColors.primary.withValues(alpha: 0.1) : AppColors.divider, 
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (widget.isStandby ? AppColors.primary : Colors.black).withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (widget.isStandby) ...[
                  _buildAnimatedRadarCircle(1.0),
                  _buildAnimatedRadarCircle(0.7),
                  _buildAnimatedRadarCircle(0.4),
                ],
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: widget.isStandby ? AppColors.primary : AppColors.divider,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (widget.isStandby ? AppColors.primary : AppColors.textGrey).withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                    gradient: widget.isStandby ? AppColors.gradient : null,
                  ),
                  child: Icon(
                    widget.isStandby ? Icons.radar_rounded : Icons.power_settings_new_rounded,
                    color: AppColors.white,
                    size: 44,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              widget.isStandby ? "Mencari Tugas Darurat..." : "Status Istirahat",
              style: AppTypography.h3.copyWith(
                color: widget.isStandby ? AppColors.primary : AppColors.textGrey,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isStandby ? "Tetap di area jangkauan radar" : "Aktifkan toggle untuk mulai bekerja",
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                fontSize: 13,
                color: AppColors.textGrey.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedRadarCircle(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double progress = (_controller.value + (1 - delay)) % 1.0;
        return Opacity(
          opacity: (1 - progress) * 0.3,
          child: Container(
            width: 90 + (progress * 150),
            height: 90 + (progress * 150),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}

