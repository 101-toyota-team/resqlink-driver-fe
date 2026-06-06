import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_typography.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Notification Data
    final List<Map<String, dynamic>> notifications = [
      {
        "type": "emergency",
        "title": "Tugas Darurat Selesai",
        "message": "Anda baru saja menyelesaikan tugas ke RS Universitas Indonesia. Saldo pendapatan telah diperbarui.",
        "time": "10 Menit Lalu",
        "isRead": false,
      },
      {
        "type": "system",
        "title": "Verifikasi Akun Berhasil",
        "message": "Dokumen kendaraan Anda telah diverifikasi oleh tim admin ResQLink. Anda kini siap menerima penugasan.",
        "time": "2 Jam Lalu",
        "isRead": true,
      },
      {
        "type": "info",
        "title": "Tips Keselamatan Berkendara",
        "message": "Pastikan selalu mengecek tekanan ban dan ketersediaan oksigen sebelum memulai shift Anda.",
        "time": "Kemarin, 09:00",
        "isRead": true,
      },
      {
        "type": "emergency",
        "title": "Bonus Insentif Mingguan",
        "message": "Selamat! Anda mencapai target performa minggu ini. Bonus Rp50.000 telah masuk ke dompet digital.",
        "time": "2 Hari Lalu",
        "isRead": true,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Notifikasi",
          style: AppTypography.title.copyWith(color: const Color(0xFF1C1C1C), fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1C1C1C), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF0F0F0), height: 1),
        ),
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(notifications[index]);
              },
            ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> data) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (data['type']) {
      case 'emergency':
        icon = Icons.emergency_rounded;
        iconColor = AppColors.primary;
        bgColor = AppColors.primary.withValues(alpha: 0.1);
        break;
      case 'system':
        icon = Icons.verified_user_rounded;
        iconColor = const Color(0xFF00AA13);
        bgColor = const Color(0xFF00AA13).withValues(alpha: 0.1);
        break;
      case 'info':
      default:
        icon = Icons.lightbulb_outline_rounded;
        iconColor = AppColors.amber;
        bgColor = AppColors.amber.withValues(alpha: 0.1);
        break;
    }

    bool isRead = data['isRead'] ?? true;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xFFFFF8F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRead ? const Color(0xFFF0F0F0) : AppColors.primary.withValues(alpha: 0.1),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['title'],
                      style: AppTypography.title.copyWith(
                        fontSize: 15,
                        color: const Color(0xFF1C1C1C),
                        fontWeight: isRead ? FontWeight.w700 : FontWeight.w800,
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  data['message'],
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF757575),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data['time'],
                  style: AppTypography.captionSmall.copyWith(
                    color: const Color(0xFFBDBDBD),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20),
              ],
            ),
            child: Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey.shade300),
          ),
          const SizedBox(height: 24),
          Text(
            "Belum Ada Notifikasi",
            style: AppTypography.h3.copyWith(color: const Color(0xFF1C1C1C)),
          ),
          const SizedBox(height: 8),
          Text(
            "Info penugasan dan berita terbaru akan muncul di sini.",
            style: AppTypography.body.copyWith(color: const Color(0xFF757575)),
          ),
        ],
      ),
    );
  }
}
