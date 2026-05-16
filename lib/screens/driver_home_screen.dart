import 'package:flutter/material.dart';
import '../../widgets/home/driver_hero_performance_card.dart';
import '../../widgets/home/driver_ongoing_task_card.dart';
import '../../widgets/home/driver_standby_radar_button.dart';
import '../../widgets/home/driver_tips_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DE), 
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeroHeaderSection(),
              
              const DriverHeroPerformanceCard(),
              
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: widget.currentStep > 0 
                    ? DriverOngoingTaskCard(
                        currentStep: widget.currentStep,
                        onOpenTaskRoute: widget.onOpenTaskRoute,
                      )
                    : DriverStandbyRadarButton(
                        isStandby: _isStandby,
                        onSimulateAssignment: widget.onSimulateAssignment,
                      ),
              ),

              const SizedBox(height: 20),

              const DriverTipsCard(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeaderSection() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF3DE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          _buildGreetingSection(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Image.asset(
            'assets/images/ResQLink_Logo.png', 
            width: 110, height: 35, 
            fit: BoxFit.contain
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 2, top: 2, bottom: 2),
            decoration: BoxDecoration(
              color: _isStandby ? const Color(0xFFE2FBE9) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _isStandby ? Colors.green.shade400 : Colors.grey.shade300, 
                width: 1.2
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
              ]
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isStandby ? "SIAP SIAGA" : "ISTIRAHAT",
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: _isStandby ? Colors.green.shade800 : Colors.grey.shade700, letterSpacing: 0.3),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: _isStandby,
                    onChanged: (value) {
                      setState(() { _isStandby = value; });
                    },
                    activeColor: Colors.green.shade700,
                    activeTrackColor: Colors.green.shade200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selamat Tugas,', style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(
            "Budi Santoso", 
            style: const TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w800, letterSpacing: -0.5)
          ),
        ],
      ),
    );
  }
}