import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart'; // Jangan lupa import ini!
import 'package:iconsax/iconsax.dart';

class HealthcareBottomNavbar extends StatelessWidget {
  final int currentIndex;

  const HealthcareBottomNavbar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            context: context, // Oper context-nya
            icon: Iconsax.home_15,
            label: "Home",
            index: 0,
            routePath: '/home-healthcare', // Sesuai dengan app_router.dart
          ),
          _navItem(
            context: context,
            icon: Iconsax.map_15,
            label: "Map",
            index: 1,
            routePath: '/map', // Sesuaikan jika ada route map
          ),
          _navItem(
            context: context,
            icon: Iconsax.document_text_15,
            label: "News",
            index: 2,
            routePath: '/news-healthcare', // Rute menuju halaman beritamu!
          ),
          _navItem(
            context: context,
            icon: Iconsax.profile_2user,
            label: "Patients",
            index: 3,
            routePath: '/patient-management',
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required String routePath, // Menerima alamat route
  }) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        print("CCTV: Tombol $label diklik! Mau pergi ke: $routePath");
        // Kalau tombol yang ditekan bukan halaman saat ini, baru pindah
        if (!isActive) {
          context.go(routePath);
        }
      },

      behavior:
          HitTestBehavior
              .opaque, // Pastikan seluruh area teks & ikon bisa diklik
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: isActive ? const Color(0xFF006E1C) : const Color(0xFF94A3B8),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color:
                  isActive ? const Color(0xFF006E1C) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
