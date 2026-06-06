import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Section with Status Badge
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.03),
              border: Border(bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.3))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusBadge(),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 16, color: AppColors.amber),
                    const SizedBox(width: 6),
                    Text(
                      "12:35",
                      style: AppTypography.label.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route Info Section (Pickup -> Destination)
                _buildRouteSection(),
                
                const SizedBox(height: 28),
                
                // Patient & Type Info
                Row(
                  children: [
                    _buildInfoItem(
                      icon: Icons.person_outline_rounded,
                      label: "PASIEN",
                      value: "Joyney Dissy",
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoItem(
                      icon: Icons.medical_services_outlined,
                      label: "KATEGORI",
                      value: "Medis Gawat",
                      color: AppColors.ambulanceJenazah,
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                
                // Step Tracker
                Text(
                  "STATUS PENUGASAN",
                  style: AppTypography.captionSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.textGrey.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                _buildStepTracker(),
                
                const SizedBox(height: 32),
                
                // Action Button
                _buildActionButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "TUGAS AKTIF",
            style: AppTypography.captionSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const Icon(Icons.radio_button_checked_rounded, color: AppColors.amber, size: 20),
            Container(
              width: 2,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.amber,
                    AppColors.ambulanceJenazah.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
            const Icon(Icons.location_on_rounded, color: AppColors.ambulanceJenazah, size: 20),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationItem("Penjemputan", "Jl. Margonda Raya No.124", AppColors.textGrey),
              const SizedBox(height: 24),
              _buildLocationItem("Rumah Sakit Tujuan", "RS Universitas Indonesia", AppColors.textDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationItem(String label, String address, Color addressColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.captionSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textGrey.withValues(alpha: 0.6),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: AppTypography.title.copyWith(
            fontSize: 15,
            color: addressColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label, required String value, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.captionSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textGrey.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    value,
                    style: AppTypography.label.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTracker() {
    final steps = ["Diterima", "Jemput", "Ke RS", "Selesai"];
    return Row(
      children: List.generate(steps.length, (index) {
        bool isCompleted = currentStep > index + 1;
        bool isActive = currentStep == index + 1;
        
        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? AppColors.primary : (isActive ? AppColors.white : AppColors.divider.withValues(alpha: 0.3)),
                      border: Border.all(
                        color: isCompleted || isActive ? AppColors.primary : AppColors.divider,
                        width: 2,
                      ),
                      boxShadow: isActive ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ] : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : Text(
                              "${index + 1}",
                              style: AppTypography.captionSmall.copyWith(
                                fontWeight: FontWeight.w900,
                                color: isActive ? AppColors.primary : AppColors.textGrey,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    steps[index],
                    style: AppTypography.captionSmall.copyWith(
                      fontWeight: isActive || isCompleted ? FontWeight.w800 : FontWeight.w500,
                      color: isActive || isCompleted ? AppColors.textDark : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.primary : AppColors.divider.withValues(alpha: 0.5),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onOpenTaskRoute,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              "Buka Peta & Navigasi",
              style: AppTypography.button.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

