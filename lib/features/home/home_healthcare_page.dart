import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tb_trace/core/widgets/healthcare_bottom_navbar.dart';

class HomeHealthcarePage extends StatelessWidget {
  const HomeHealthcarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF1),

      // ================= BOTTOM NAVBAR =================
      bottomNavigationBar: const HealthcareBottomNavbar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),

              // ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.notifications_none_rounded, size: 26),

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Hello,",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "Dr. Sarah",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 10.w),

                      GestureDetector(
                        onTap: () {
                          context.go('/profile');
                        },

                        child: CircleAvatar(
                          radius: 22.r,
                          backgroundColor: const Color(0xFFEEF2F3),

                          child: Icon(Icons.person, size: 24.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // ================= WELCOME =================
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Pagi, Dr. Sarah",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF171D17),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      "Tetap aman dan dapatkan informasi terbaru hari ini.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF3D4A3F),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // ================= ACTIVE CASE =================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFEFF6EC)],
                  ),
                  border: Border.all(color: const Color(0xFFE2E8E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Iconsax.activity,
                          color: Color(0xFF006D37),
                          size: 18,
                        ),

                        SizedBox(width: 8.w),

                        Text(
                          "Kasus Aktif",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF006D37),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    Text(
                      "124",
                      style: TextStyle(
                        fontSize: 42.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF171D17),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: Color(0xFFBA1A1A),
                          size: 18,
                        ),

                        SizedBox(width: 4.w),

                        Text(
                          "+12",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFBA1A1A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(width: 6.w),

                        Text(
                          "Sejak minggu lalu",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF3D4A3F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // ================= SMALL CARDS =================
              Row(
                children: [
                  Expanded(
                    child: _smallCard(
                      title: "Recovered",
                      value: "89",
                      subtitle: "Bulan ini",
                      color: const Color(0xFF61DE8A),
                      icon: Icons.favorite_outline,
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: _smallCard(
                      title: "New Alerts",
                      value: "7",
                      subtitle: "Requires attention",
                      color: const Color(0xFFBA1A1A),
                      icon: Icons.warning_amber_rounded,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // ================= SYMPTOM CARD =================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFE2E8E0)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Symptom Trends",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        Text(
                          "Last 7 Days",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    _progressItem("Batuk Terus Menerus", 0.85),

                    SizedBox(height: 16.h),

                    _progressItem("Demam", 0.62),

                    SizedBox(height: 16.h),

                    _progressItem("Berkeringat Malam", 0.45),

                    SizedBox(height: 16.h),

                    _progressItem("Kepatuhan Minum Obat", 0.92),
                  ],
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SMALL CARD =================
  Widget _smallCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [Colors.white, color.withOpacity(0.08)],
        ),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              SizedBox(width: 6.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          Text(
            value,
            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 4.h),

          Text(
            subtitle,
            style: TextStyle(fontSize: 13.sp, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ================= PROGRESS ITEM =================
  Widget _progressItem(String title, double value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 14.sp)),

            Text(
              "${(value * 100).toInt()}%",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF006D37),
              ),
            ),
          ],
        ),

        SizedBox(height: 6.h),

        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8.h,
            backgroundColor: const Color(0xFFDDE5DB),
            valueColor: const AlwaysStoppedAnimation(Color(0xFF006D37)),
          ),
        ),
      ],
    );
  }

  // ================= NAV ITEM =================
  Widget _navItem({
    required IconData icon,
    required String label,
    bool active = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: active ? const Color(0xFF006E1C) : const Color(0xFF94A3B8),
        ),

        SizedBox(height: 4.h),

        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? const Color(0xFF006E1C) : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}
