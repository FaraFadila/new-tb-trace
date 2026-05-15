import '../../core/widgets/patient_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class HomePatientPage extends StatelessWidget {
  const HomePatientPage({super.key});

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF1),

      // ================= BOTTOM NAV =================
      bottomNavigationBar:
      const PatientBottomNavbar(
        currentIndex: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              // ================= HEADER =================
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.notifications_none,
                    size: 26,
                  ),

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Hello,",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "Jade West",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 10.w),

                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor:
                            const Color(
                          0xFFEEF2F3,
                        ),
                        child: const Icon(
                          Icons.person,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // ================= WELCOME =================
              Text(
                "Selamat Pagi, Sarah",
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

              SizedBox(height: 20.h),

              // ================= RISK CARD =================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE8F8F1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                      color: Colors.black
                          .withOpacity(0.04),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              "STATUS LOKASI SAAT INI",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight:
                                    FontWeight.w700,
                                letterSpacing: 1,
                                color:
                                    const Color(
                                  0xFF53615C,
                                ),
                              ),
                            ),

                            SizedBox(height: 6.h),

                            Text(
                              "Kebraon",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding:
                              EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF006D37,
                            ).withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(
                              999.r,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration:
                                    const BoxDecoration(
                                  color: Color(
                                    0xFF006D37,
                                  ),
                                  shape:
                                      BoxShape.circle,
                                ),
                              ),

                              SizedBox(width: 6.w),

                              Text(
                                "LOW RISK",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                  color:
                                      const Color(
                                    0xFF006D37,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration:
                              BoxDecoration(
                            color: const Color(
                              0xFF27AE60,
                            ).withOpacity(0.2),
                            shape:
                                BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.location5,
                            color:
                                Color(0xFF006D37),
                          ),
                        ),

                        SizedBox(width: 12.w),

                        Expanded(
                          child: Text(
                            "Tidak ada laporan kasus TBC aktif baru-baru ini di sekitar Anda. Tetap lakukan tindakan pencegahan standar.",
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.5,
                              color:
                                  const Color(
                                0xFF3D4A3F,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              // ================= QUICK ACTION =================
              Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: _quickActionCard(
                      title:
                          "Zona Aman\nTerdekat",
                      icon: Iconsax.location,
                      isPrimary: false,
                    ),
                  ),

                  SizedBox(width: 16.w),

                  Expanded(
                    child: _quickActionCard(
                      title:
                          "Laporkan\nGejala",
                      icon:
                          Iconsax.warning_2,
                      isPrimary: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // ================= INFO SECTION =================
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Informasi TBC",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  Text(
                    "LIHAT SEMUA",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight:
                          FontWeight.w700,
                      letterSpacing: 1,
                      color:
                          const Color(0xFF006D37),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              SizedBox(
                height: 260.h,
                child: ListView(
                  scrollDirection:
                      Axis.horizontal,
                  children: [
                    _articleCard(
                      imagePath: "assets/images/tbc1.png",
                      category: "Pencegahan",
                      title:
                          "Atasi Stigma Pasien TBC",
                      author: "dr. panpan",
                    ),

                    SizedBox(width: 16.w),

                    _articleCard(
                      imagePath: "assets/images/tbc1.png",
                      category: "Kesehatan",
                      title:
                          "Tips Menjaga Imunitas",
                      author: "dr. Sarah",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  // ================= QUICK ACTION =================
  Widget _quickActionCard({
    required String title,
    required IconData icon,
    required bool isPrimary,
  }) {
    return Container(
      //height: 140.h,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: isPrimary
            ? const LinearGradient(
                colors: [
                  Color(0xFF27AE60),
                  Color(0xFF006D37),
                ],
              )
            : null,
        color: isPrimary
            ? null
            : Colors.white,
        borderRadius:
            BorderRadius.circular(16.r),
        border: isPrimary
            ? null
            : Border.all(
                color:
                    const Color(0xFFE8F8F1),
              ),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: isPrimary
                  ? Colors.white
                      .withOpacity(0.2)
                  : const Color(
                      0xFFD6E6DF,
                    ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isPrimary
                  ? Colors.white
                  : const Color(
                      0xFF596862,
                    ),
            ),
          ),

          SizedBox(height: 14.h),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: isPrimary
                  ? Colors.white
                  : const Color(
                      0xFF171D17,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= ARTICLE CARD =================
  Widget _articleCard({
    required String imagePath,
    required String category,
    required String title,
    required String author,
  }) {
    return Container(
      width: 260.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE8F8F1),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            height: 130.h,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFDDE5DB),
              borderRadius:
                  BorderRadius.vertical(
                top: Radius.circular(
                  16.r,
                ),
              ),
            ),
            child: Center(
              child: Image.asset(
                imagePath , 
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: 1,
                    color:
                        const Color(
                      0xFF53615C,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        const Color(
                      0xFF171D17,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  author,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color:
                        const Color(
                      0xFF3D4A3F,
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

  // ================= NAV ITEM =================
  Widget _navItem({
    required IconData icon,
    required String label,
    bool active = false,
  }) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: active
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
            color: active
                ? const Color(0xFF059669)
                : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}