import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.w,
          ),
          child: Column(
            children: [
              SizedBox(height: 80.h),

              // ================= LOGO =================
              Text(
                "TB-Trace",
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF007A33),
                ),
              ),

              SizedBox(height: 80.h),

              // ================= ILLUSTRATION =================
              SizedBox(
                height: 260.h,
                child: Image.asset(
                  'assets/images/start_illustration.png',
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 60.h),

              // ================= TITLE =================
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Monitoring TBC Berbasis Lokasi",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: const Color(0xFF171D17),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // ================= DESCRIPTION =================
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pantau persebaran dan aktivitas pasien TBC secara real-time untuk mendukung penanganan yang lebih cepat dan tepat",
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 1.7,
                    color: const Color(0xFF3D4A3F),
                  ),
                ),
              ),

              const Spacer(),

              // ================= BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 58.h,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF008236),

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16.r,
                      ),
                    ),
                  ),

                  child: Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}