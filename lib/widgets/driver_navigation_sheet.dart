import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_typography.dart';
import 'order/pre_hospital_medical_form.dart';

class DriverNavigationSheet extends StatefulWidget {
  final String passengerName;
  final String notes;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onButtonPressed;
  final bool showMedicalForm;

  const DriverNavigationSheet({
    super.key,
    required this.passengerName,
    required this.notes,
    required this.buttonText,
    required this.buttonColor,
    required this.onButtonPressed,
    this.showMedicalForm = false,
  });

  @override
  State<DriverNavigationSheet> createState() => _DriverNavigationSheetState();
}

class _DriverNavigationSheetState extends State<DriverNavigationSheet> {
  bool _isMedicalFormCompleted = false;

  void _showMedicalForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: PreHospitalMedicalForm(
          onSaved: () {
            setState(() {
              _isMedicalFormCompleted = true;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          
          // Passenger Info Row
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person_rounded, color: Color(0xFF757575), size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.passengerName, 
                      style: AppTypography.title.copyWith(
                        fontSize: 18, 
                        color: const Color(0xFF1C1C1C),
                        fontWeight: FontWeight.w800
                      )
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.notes, 
                      style: AppTypography.caption.copyWith(
                        fontSize: 13, 
                        color: const Color(0xFF757575),
                        fontWeight: FontWeight.w500,
                      ), 
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis
                    ),
                  ],
                ),
              ),
              // Communication Actions
              _buildSmallIconButton(Icons.chat_bubble_rounded, AppColors.primary),
              const SizedBox(width: 12),
              _buildSmallIconButton(Icons.call_rounded, AppColors.primary),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Medical Form Section (if applicable)
          if (widget.showMedicalForm) ...[
            _buildMedicalFormButton(),
            const SizedBox(height: 20),
          ],
          
          // Main Action Button
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: widget.onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.buttonColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                widget.buttonText, 
                style: AppTypography.button.copyWith(
                  fontSize: 16, 
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallIconButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1.2),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildMedicalFormButton() {
    return InkWell(
      onTap: () => _showMedicalForm(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _isMedicalFormCompleted 
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.amber.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isMedicalFormCompleted 
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.amber.withValues(alpha: 0.2),
            width: 1.2
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isMedicalFormCompleted ? AppColors.primary : AppColors.amber,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isMedicalFormCompleted ? Icons.check_rounded : Icons.medical_information_rounded, 
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isMedicalFormCompleted ? "Data Medis Tersimpan" : "Observasi Medis Pasien",
                    style: AppTypography.label.copyWith(
                      color: const Color(0xFF1C1C1C),
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _isMedicalFormCompleted ? "Siap untuk diserahkan ke RS" : "Mohon lengkapi sebelum sampai RS",
                    style: AppTypography.captionSmall.copyWith(
                      color: const Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFBDBDBD)),
          ],
        ),
      ),
    );
  }
}


