import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/driver_service.dart';
import '../services/location_service.dart';
import '../themes/app_typography.dart';
import '../models/booking.dart';
import 'login_screen.dart';
import 'notification_screen.dart';
import '../widgets/home/driver_hero_performance_card.dart';
import '../widgets/home/driver_ongoing_task_card.dart';
import '../widgets/home/driver_tips_card.dart';
import '../widgets/order/order_request_card.dart';
import '../themes/app_colors.dart';
import '../themes/app_theme.dart';

class DriverHomeScreen extends StatefulWidget {
  final int currentStep;
  final Function(Booking) onStartAssignment;
  final VoidCallback onOpenTaskRoute;

  const DriverHomeScreen({
    super.key,
    required this.currentStep,
    required this.onStartAssignment,
    required this.onOpenTaskRoute,
  });

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isStandby = false;
  String _driverName = "Mitra ResQLink";
  List<Booking> _assignments = [];
  bool _isFetching = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _getDriverInfo();
    // Berikan sedikit jeda atau cek session sebelum memulai polling untuk menghindari 401 saat startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAssignmentPolling();
    });
  }

  void _startAssignmentPolling() {
    _refreshTimer?.cancel();
    // Berikan jeda 2 detik untuk memastikan session benar-benar settle setelah hot restart/startup
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _updateAssignmentsFromServer();
        _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) => _updateAssignmentsFromServer());
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
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

  Future<void> _updateAssignmentsFromServer() async {
    // Cek apakah ada session aktif sebelum sinkronisasi
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null || _isFetching || widget.currentStep >= 2) return;
    
    setState(() => _isFetching = true);
    try {
      final List<dynamic> data = await DriverService.getDriverAssignments();
      debugPrint('DEBUG: Fetched ${data.length} assignments from API');
      
      final List<Booking> fetched = data.map((j) => Booking.fromJson(j)).toList();
      
      if (mounted) {
        setState(() {
          // Filter hanya yang statusnya confirmed
          _assignments = fetched.where((b) => b.status == BookingStatus.confirmed).toList();
          debugPrint('DEBUG: Found ${_assignments.length} assignments with status CONFIRMED');
        });
      }
    } catch (e) {
      debugPrint('DEBUG: Error updating assignments: $e');
      // Jika Unauthorized, kosongkan list penugasan
      if (e.toString().contains('401') && mounted) {
        setState(() => _assignments = []);
      }
    } finally {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  void _toggleStandby(bool value) {
    setState(() { 
      _isStandby = value;
    });
    // Jangan biarkan error sync status menghentikan UI, tapi tetap log
    DriverService.updateStatus(value).then((_) {
      if (value) _updateAssignmentsFromServer();
    }).catchError((e) {
      debugPrint('DEBUG: Error sync status: $e');
    });
  }

  Future<void> _handleLogout() async {
    _refreshTimer?.cancel();
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
        child: RefreshIndicator(
          onRefresh: _updateAssignmentsFromServer,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              _buildTopBar(),
              _buildGreetingSection(),
              
              const DriverHeroPerformanceCard(),
              const SizedBox(height: 12),

              // Area Aksi Utama (Tugas Aktif, Penugasan Baru, atau Placeholder Standby)
              if (widget.currentStep >= 2)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DriverOngoingTaskCard(
                    currentStep: widget.currentStep,
                    onOpenTaskRoute: widget.onOpenTaskRoute,
                  ),
                )
              else if (_assignments.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OrderRequestCard(
                    booking: _assignments.first,
                    onAccept: () => widget.onStartAssignment(_assignments.first),
                  ),
                )
              else if (_isStandby)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildStandbyPlaceholder(),
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

  Widget _buildStandbyPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 40),
          ),
          const SizedBox(height: 24),
          Text("Siap Melayani", style: AppTypography.h3.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(
            "Anda akan menerima penugasan langsung di sini jika sudah dikonfirmasi oleh provider.",
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: Colors.grey.shade600, fontSize: 13),
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
                onChanged: _toggleStandby,
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
