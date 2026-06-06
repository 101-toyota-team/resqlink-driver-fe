import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class ActivityRouteInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;

  const ActivityRouteInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.textGrey.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: AppColors.textGrey),
        ),
        const SizedBox(width: 10),
        Text(
          "$label: ", 
          style: AppTypography.caption.copyWith(fontSize: 13, color: AppColors.textGrey),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTypography.body.copyWith(
              fontSize: 13, 
              fontWeight: FontWeight.w700, 
              color: AppColors.textDark,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
