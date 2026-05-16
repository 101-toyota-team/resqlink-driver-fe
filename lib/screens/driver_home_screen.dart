import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

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
      backgroundColor: const Color(0xFFFFF3DE), // Latar krem lembut konsisten
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 1. HERO CONTAINER DENGAN TOPBAR & GREETING
              _buildHeroHeaderSection(),
              
              // 2. HERO PERFORMANCE BANNER (INTEGRASI MAPS GLASSMORPHISM)
              _buildHeroBannerWithPerformance(),
              
              const SizedBox(height: 20),

              // 3. EMERGENCY FLOW (CARD DARURAT / STANDBY BUTTON)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: widget.currentStep > 0 
                    ? _buildOngoingTaskCard()
                    : _buildStandbyButton(),
              ),

              const SizedBox(height: 20),

              // 4. SYSTEM STANDBY INFO CARD
              _buildTipsCard(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- KUMPULAN WIDGET LAYOUT ---

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
            width: 110, 
            height: 35, 
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
                  style: TextStyle(
                    fontSize: 9, 
                    fontWeight: FontWeight.w900, 
                    color: _isStandby ? Colors.green.shade800 : Colors.grey.shade700,
                    letterSpacing: 0.3
                  ),
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

  Widget _buildHeroBannerWithPerformance() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9E5C11).withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Peta Oranye
            Image.asset(
              'assets/images/resqlink-banner.png',
              width: double.infinity,
              height: 165,
              fit: BoxFit.cover,
            ),
            
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.4),
              ),
            ),
            
            // Konten Data Statistik di Atas Peta
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pendapatan Hari Ini", 
                    style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.2)
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Rp600.000", 
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF9E5C11), letterSpacing: -0.5)
                  ),
                  const SizedBox(height: 14),
                  
                  // Divider Lembut Transparan
                  Container(width: double.infinity, height: 1.2, color: const Color(0xFF9E5C11).withOpacity(0.15)),
                  const SizedBox(height: 14),
                  
                  Row(
                    children: [
                      _buildHeroMetricItem(Icons.assignment_turned_in_rounded, "Total Tugas", "2", Colors.orange.shade900),
                      Container(
                        width: 1.5, 
                        height: 24, 
                        color: const Color(0xFF9E5C11).withOpacity(0.2), 
                        margin: const EdgeInsets.symmetric(horizontal: 20)
                      ),
                      _buildHeroMetricItem(Icons.star_rounded, "Rating Driver", "4.9", Colors.amber.shade900),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroMetricItem(IconData icon, String label, String value, Color colorIcon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colorIcon),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.w600)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black87)),
          ],
        ),
      ],
    );
  }

  Widget _buildOngoingTaskCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF9E5C11).withOpacity(0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Peta Mini dengan Pin Label
          Stack(
            children: [
              Image.asset(
                'assets/images/resqlink-banner.png',
                width: double.infinity,
                height: 90,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 12, left: 16,
                child: _buildMapPinBadge(Icons.location_on, "Penjemputan", Colors.orange.shade800),
              ),
              Positioned(
                bottom: 12, right: 16,
                child: _buildMapPinBadge(Icons.local_hospital, "Tujuan", Colors.green.shade700),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_rounded, color: Colors.red, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "TUGAS DARURAT SEDANG BERJALAN",
                      style: TextStyle(
                        fontWeight: FontWeight.w900, 
                        fontSize: 11, 
                        color: Colors.red.shade800, 
                        letterSpacing: 0.5
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Grid Info Pasien & Rumah Sakit
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTaskDetailColumn(
                        icon: Icons.person_rounded,
                        title: "Pasien",
                        mainText: "Joyney Dissy",
                        subText: "Kontak: +62 857-1100",
                        colorTheme: const Color(0xFF9E5C11),
                      ),
                    ),
                    Container(width: 1, height: 45, color: Colors.grey.shade200, margin: const EdgeInsets.symmetric(horizontal: 12)),
                    Expanded(
                      child: _buildTaskDetailColumn(
                        icon: Icons.local_hospital_rounded,
                        title: "Rumah Sakit Tujuan",
                        mainText: "RS Universitas Indonesia",
                        subText: "Usia: 30 | Darah: O-",
                        colorTheme: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Info Waktu Penugasan
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.access_time_filled_rounded, size: 16, color: Color(0xFF9E5C11)),
                          SizedBox(width: 6),
                          Text("Waktu Penugasan", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black54)),
                        ],
                      ),
                      const Text(
                        "12:35 Menit Berlalu",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9E5C11)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Status Alur Penugasan", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.black54)),
                const SizedBox(height: 8),
                
                // Linear Progress Tracker
                _buildDriverStepTracker(),
                const SizedBox(height: 18),

                // Tombol Buka Navigasi
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Container(
                    // Bungkus dengan Container untuk mengaplikasikan LinearGradient dari AppColors
                    decoration: BoxDecoration(
                      gradient: AppColors.gradient,
                      borderRadius: BorderRadius.circular(12), // Harus disamakan dengan border radius button
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9E5C11).withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: widget.onOpenTaskRoute,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Set transparan agar warna gradient di belakangnya muncul
                        shadowColor: Colors.transparent,     // Hilangkan shadow bawaan button karena sudah diganti boxShadow Container
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.zero, // Hilangkan padding bawaan agar konten mengisi penuh container gradient
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Buka Peta & Navigasi", 
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPinBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildTaskDetailColumn({required IconData icon, required String title, required String mainText, required String subText, required Color colorTheme}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: colorTheme),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(mainText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87), overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(subText, style: const TextStyle(fontSize: 10.5, color: Colors.black54), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverStepTracker() {
    final steps = ["Diterima", "Jemput", "Ke RS", "Selesai"];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (index) {
        int stepNum = index + 1;
        bool isDone = widget.currentStep > stepNum;
        bool isActive = widget.currentStep == stepNum;

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? const Color(0xFF9E5C11) : (isActive ? Colors.amber.shade700 : Colors.grey.shade200),
                      border: isActive ? Border.all(color: const Color(0xFF9E5C11), width: 1.5) : null,
                    ),
                    child: Center(
                      child: isDone 
                          ? const Icon(Icons.check, size: 11, color: Colors.white)
                          : Text("$stepNum", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.black54)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(steps[index], style: TextStyle(fontSize: 9, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? const Color(0xFF9E5C11) : Colors.black54)),
                ],
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 14),
                    color: widget.currentStep > stepNum ? const Color(0xFF9E5C11) : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStandbyButton() {
    return GestureDetector(
      onTap: () {
        if (!_isStandby) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ubah status ke SIAP SIAGA terlebih dahulu!")));
          return;
        }
        widget.onSimulateAssignment(); 
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(width: 140, height: 140, decoration: BoxDecoration(shape: BoxShape.circle, color: _isStandby ? const Color(0xFF9E5C11).withOpacity(0.08) : Colors.grey.withOpacity(0.04))),
          Container(
            width: 95, height: 95,
            decoration: BoxDecoration(
              shape: BoxShape.circle, 
              gradient: AppColors.gradient,
              boxShadow: [
                BoxShadow(color: (const Color(0xFF9E5C11)).withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_isStandby ? Icons.gpp_good_rounded : Icons.power_settings_new_rounded, color: Colors.white, size: 28),
                const SizedBox(height: 4),
                Text(
                  _isStandby ? "Menunggu\nTugas" : "Mulai Aktif", 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, height: 1.2)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9EE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF9E5C11).withOpacity(0.15), width: 1.2),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Color(0xFF9E5C11), size: 22),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sistem Otomatis Aktif", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                  const SizedBox(height: 2),
                  Text(
                    "Pastikan status Anda tetap 'Siap Siaga' agar provider dapat langsung mengalokasikan darurat terdekat.",
                    style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}