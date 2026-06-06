import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_typography.dart';

class DriverBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const DriverBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF757575),
        showUnselectedLabels: true,
        selectedLabelStyle: AppTypography.label.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
        unselectedLabelStyle: AppTypography.label.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF757575),
        ),
        items: [
          _buildNavbarItem(Icons.home_rounded, Icons.home_outlined, "Beranda", 0),
          _buildNavbarItem(Icons.assignment_rounded, Icons.assignment_outlined, "Aktivitas", 1),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavbarItem(IconData activeIcon, IconData inactiveIcon, String label, int index) {
    bool isActive = currentIndex == index;

    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 8),
        child: Icon(
          isActive ? activeIcon : inactiveIcon, 
          color: isActive ? AppColors.primary : const Color(0xFF757575), 
          size: 24,
        ),
      ),
      label: label,
    );
  }
}