import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class PreHospitalMedicalForm extends StatefulWidget {
  final VoidCallback onSaved;
  const PreHospitalMedicalForm({super.key, required this.onSaved});

  @override
  State<PreHospitalMedicalForm> createState() => _PreHospitalMedicalFormState();
}

class _PreHospitalMedicalFormState extends State<PreHospitalMedicalForm> {
  String _selectedTriage = "MERAH";
  final Map<String, bool> _actions = {
    "Oksigen Tambahan": false,
    "Jalur Infus IV": false,
    "Resusitasi Jantung Paru": false,
    "Penyangga Leher": false,
  };

  final Map<String, String> _vitalsData = {
    "consciousness": "Compos Mentis (Sadar Penuh)",
    "bloodPressure": "120/80 mmHg",
    "spo2": "98%",
    "heartRate": "80 BPM",
    "bloodSugar": "100 mg/dL",
    "age": "30 Tahun",
    "bloodType": "O+",
  };

  Future<void> _sendDataToHospital() async {
    try {
      // Mengirim data ke npoint.io (JSON Storage publik)
      // Ini bertindak sebagai "database sementara" tanpa perlu backend rumit
      final response = await http.post(
        Uri.parse('https://api.npoint.io/3d8b5c9c9b1f2e3d4a5b'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          ..._vitalsData,
          "triage": _selectedTriage,
          "actions": _actions.entries.where((e) => e.value).map((e) => e.key).toList(),
          "lastUpdated": DateTime.now().toIso8601String(),
        }),
      );
      debugPrint("Data Medis Terkirim ke RS: ${response.statusCode}");
    } catch (e) {
      debugPrint("Gagal kirim data medis: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("KLASIFIKASI TRIASE"),
                  const SizedBox(height: 12),
                  _buildTriageSelector(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("PARAMETER TANDA VITAL"),
                  const SizedBox(height: 12),
                  _buildVitalsGrid(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("LOG TINDAKAN MEDIS (CEKLIST)"),
                  const SizedBox(height: 12),
                  _buildActionsChecklist(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Form Medis Pra-RS", style: AppTypography.h3),
            Text("Input data observasi pasien", style: AppTypography.caption),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded, color: AppColors.textGrey),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.label.copyWith(
        color: AppColors.primary,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildTriageSelector() {
    final types = ["MERAH", "KUNING", "HIJAU"];
    return Row(
      children: types.map((type) {
        bool isSelected = _selectedTriage == type;
        Color color = type == "MERAH" 
            ? AppColors.primary 
            : (type == "KUNING" ? Colors.amber.shade700 : AppColors.ambulanceJenazah);
        
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTriage = type),
            child: Container(
              margin: EdgeInsets.only(
                right: type != "HIJAU" ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? color : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? color : AppColors.divider,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  type,
                  style: AppTypography.label.copyWith(
                    color: isSelected ? AppColors.white : AppColors.textGrey,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVitalsGrid() {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            _buildVitalInput("Usia Pasien", "Thn", "30", "age"),
            _buildVitalInput("Golongan Darah", "Tipe", "O+", "bloodType"),
            _buildVitalInput("Tekanan Darah", "mmHg", "120/80", "bloodPressure"),
            _buildVitalInput("Saturasi Oksigen", "%", "98", "spo2"),
            _buildVitalInput("Detak Jantung", "BPM", "80", "heartRate"),
            _buildVitalInput("Gula Darah", "mg/dL", "100", "bloodSugar"),
          ],
        ),
      ],
    );
  }

  Widget _buildVitalInput(String label, String unit, String hint, String key) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTypography.captionSmall.copyWith(fontSize: 9)),
          const SizedBox(height: 2),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => _vitalsData[key] = val + (val.isNotEmpty ? " $unit" : ""),
                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(color: AppColors.textGrey.withValues(alpha: 0.3)),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Text(unit, style: AppTypography.captionSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsChecklist() {
    return Column(
      children: _actions.keys.map((action) {
        return CheckboxListTile(
          value: _actions[action],
          onChanged: (val) => setState(() => _actions[action] = val!),
          title: Text(action, style: AppTypography.body.copyWith(fontSize: 13)),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () async {
            await _sendDataToHospital();
            widget.onSaved();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text("Simpan & Kirim Data", style: AppTypography.button),
        ),
      ),
    );
  }
}
