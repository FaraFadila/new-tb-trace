import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class HealthcareBottomNavbar
    extends StatelessWidget {
  final int currentIndex;

  const HealthcareBottomNavbar({
    super.key,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,

      decoration: const BoxDecoration(
        color: Colors.white,

        border: Border(
          top: BorderSide(
            color: Color(0xFFE2E8F0),
          ),
        ),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            icon: Iconsax.home_15,
            label: "Home",
            index: 0,
          ),

          _navItem(
            icon: Iconsax.map_15,
            label: "Map",
            index: 1,
          ),

          _navItem(
            icon: Iconsax.document_text_15,
            label: "News",
            index: 2,
          ),

          _navItem(
            icon: Iconsax.profile_2user,
            label: "Patients",
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive =
        currentIndex == index;

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: isActive
              ? const Color(0xFF006E1C)
              : const Color(0xFF94A3B8),
        ),

        SizedBox(height: 4.h),

        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: isActive
                ? FontWeight.w600
                : FontWeight.w500,
            color: isActive
                ? const Color(0xFF006E1C)
                : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}