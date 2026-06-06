import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class DriverMapPlaceholder extends StatelessWidget {
  final String text;

  const DriverMapPlaceholder({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        image: DecorationImage(
          image: AssetImage('assets/images/medic_pattern.png'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.map_rounded, size: 48, color: AppColors.textGrey),
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: AppTypography.body.copyWith(
                color: AppColors.textGrey, 
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
