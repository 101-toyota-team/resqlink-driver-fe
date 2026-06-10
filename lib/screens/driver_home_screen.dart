import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/driver_service.dart';
import '../themes/app_typography.dart';
import 'login_screen.dart';
import 'notification_screen.dart';
import '../../widgets/home/driver_hero_performance_card.dart';
import '../../widgets/home/driver_ongoing_task_card.dart';
import '../../widgets/home/driver_tips_card.dart';
import '../../widgets/order/order_request_card.dart';
import '../../themes/app_colors.dart';

class DriverHomeScreen extends StatefulWidget {
  final int currentStep;
  final VoidCallback onSimulateAssignment;
  final VoidCallback onOpenTaskRoute;

  const DriverHomeScreen({
    super.key,
    required this.currentStep,
    required this.onSimulateAssignment,
    required this.onOpenTaskRoute,
  });

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isStandby = false;
  String _driverName = "Mitra ResQLink";

  @override
  void initState() {
    super.initState();
    _getDriverInfo();
  }

  void _getDriverInfo() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _driverName = user.userMetadata?['full_name'] ?? 
                      user.userMetadata?['name'] ?? 
                      user.email?.split('@')[0] ?? 
                      "Mitra ResQLink";
      });
    }
  }

  Future<void> _handleLogout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildGreetingSection(),
              const DriverHeroPerformanceCard(),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildMainActionArea(),
              ),
              const SizedBox(height: 24),
              const DriverTipsCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainActionArea() {
    if (widget.currentStep >= 2) {
      return DriverOngoingTaskCard(
        currentStep: widget.currentStep,
        onOpenTaskRoute: widget.onOpenTaskRoute,
      );
    }

    if (_isStandby) {
      // Tampilan "Penugasan Baru" yang langsung muncul
      return OrderRequestCard(
        onAccept: widget.onSimulateAssignment,
      );
    }

    // Tampilan saat Offline
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.power_settings_new_rounded, size: 40, color: Color(0xFFADB5BD)),
          ),
          const SizedBox(height: 24),
          Text(
            "Status Anda Offline",
            style: AppTypography.h3.copyWith(color: const Color(0xFF495057)),
          ),
          const SizedBox(height: 8),
          Text(
            "Aktifkan status AKTIF di atas untuk mulai menerima penugasan darurat secara langsung.",
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: const Color(0xFF868E96), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/ResQLink_Logo.png', 
            width: 110, height: 36, 
            fit: BoxFit.contain
          ),
          Row(
            children: [
              _buildStatusToggle(),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout_rounded, color: Color(0xFF757575), size: 22),
                tooltip: "Keluar Akun",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _isStandby ? const Color(0xFF00AA13).withValues(alpha:0.1) : Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: _isStandby ? const Color(0xFF00AA13).withValues(alpha: 0.3) : const Color(0xFFE8E8E8), 
          width: 1.2
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: _isStandby ? const Color(0xFF00AA13) : const Color(0xFFBDBDBD),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _isStandby ? "AKTIF" : "OFFLINE",
            style: AppTypography.captionSmall.copyWith(
              fontWeight: FontWeight.w900,
              color: _isStandby ? const Color(0xFF00AA13) : const Color(0xFF4A4A4A),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 20,
            width: 32,
            child: Transform.scale(
              scale: 0.7,
              child: Switch(
                value: _isStandby,
                onChanged: (value) {
                  setState(() { _isStandby = value; });
                  // Sync dengan backend di background tanpa memblokir UI
                  DriverService.updateStatus(value).catchError((e) {
                    debugPrint('Gagal sinkronisasi status ke backend: $e');
                  });
                },
                activeThumbColor: const Color(0xFF00AA13),
                activeTrackColor: const Color(0xFF00AA13).withValues(alpha: 0.2),
                inactiveThumbColor: const Color(0xFF9E9E9E),
                inactiveTrackColor: const Color(0xFFE0E0E0),
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.person_rounded, color: Color(0xFF757575), size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Halo, $_driverName", 
                  style: AppTypography.h3.copyWith(
                    fontSize: 20,
                    color: const Color(0xFF1C1C1C),
                  ),
                ),
                Text(
                  'Siap melayani darurat hari ini?',
                  style: AppTypography.caption.copyWith(
                    color: const Color(0xFF757575),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF0F0F0)),
              ),
              child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF4A4A4A), size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
