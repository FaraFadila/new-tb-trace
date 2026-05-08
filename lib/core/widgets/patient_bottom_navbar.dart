import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tb_trace/core/widgets/healthcare_bottom_navbar.dart';

class PatientBottomNavbar extends StatelessWidget {
  final int currentIndex;

  const PatientBottomNavbar({
    super.key,
    this.currentIndex = 0,a
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),

        border: const Border(
          top: BorderSide(
            color: Color(0xFFE8F8F1),
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            icon: Iconsax.home_15,
            label: "HOME",
            index: 0,
          ),

          _navItem(
            icon: Iconsax.map_15,
            label: "MAP",
            index: 1,
          ),

          _navItem(
            icon: Iconsax.document_text_15,
            label: "NEWS",
            index: 2,
          ),

          _navItem(
            icon: Iconsax.profile_circle,
            label: "PROFILE",
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
              ? const Color(0xFF059669)
              : const Color(0xFF94A3B8),
        ),

        SizedBox(height: 6.h),

        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            color: isActive
                ? const Color(0xFF059669)
                : const Color(0xFF94A3B8),
          ),
        ),

        SizedBox(height: 4.h),

        if (isActive)
          Container(
            width: 24.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(
                0xFF10B981,
              ).withOpacity(0.2),

              borderRadius:
                  BorderRadius.circular(
                999.r,
              ),
            ),
          ),
      ],
    );
  }
}