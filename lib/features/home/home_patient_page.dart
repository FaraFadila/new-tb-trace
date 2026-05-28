import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tb_trace/core/services/news_api_service.dart';
import 'package:tb_trace/core/widgets/app_user_header.dart';

import '../../core/widgets/patient_bottom_navbar.dart';

class HomePatientPage extends StatefulWidget {
  const HomePatientPage({super.key});

  @override
  State<HomePatientPage> createState() => _HomePatientPageState();
}

class _HomePatientPageState extends State<HomePatientPage> {
  final NewsApiService _newsService = NewsApiService();
  late final Future<List<NewsApiArticle>> _newsPreviewFuture;

  @override
  void initState() {
    super.initState();
    _newsPreviewFuture = _newsService.fetchTuberculosisNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF1),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: const PatientBottomNavbar(currentIndex: 0),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              // ================= HEADER =================
              const AppUserHeader(
                includeSafeArea: false,
                showBackground: false,
                showBorder: false,
                showShadow: false,
                horizontalPadding: 0,
                verticalPadding: 0,
                profileRoute: '/profile-patient',
              ),

              SizedBox(height: 24.h),

              // ================= WELCOME =================
              CurrentUserNameText(
                builder:
                    (context, displayName) => Text(
                      "Selamat Pagi, $displayName",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF171D17),
                      ),
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
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFE8F8F1)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                      color: Colors.black.withValues(alpha: 0.04),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "STATUS LOKASI SAAT INI",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: const Color(0xFF53615C),
                              ),
                            ),

                            SizedBox(height: 6.h),

                            Text(
                              "Kebraon",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF006D37,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF006D37),
                                  shape: BoxShape.circle,
                                ),
                              ),

                              SizedBox(width: 6.w),

                              Text(
                                "LOW RISK",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF006D37),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF27AE60,
                            ).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.location5,
                            color: Color(0xFF006D37),
                          ),
                        ),

                        SizedBox(width: 12.w),

                        Expanded(
                          child: Text(
                            "Tidak ada laporan kasus TBC aktif baru-baru ini di sekitar Anda. Tetap lakukan tindakan pencegahan standar.",
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.5,
                              color: const Color(0xFF3D4A3F),
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
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: _quickActionCard(
                      title: "Zona Aman\nTerdekat",
                      icon: Iconsax.location,
                      isPrimary: false,
                      onTap: () => context.go('/patient-map'),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  Expanded(
                    child: _quickActionCard(
                      title: "Laporkan\nGejala",
                      icon: Iconsax.warning_2,
                      isPrimary: true,
                      onTap: () => context.push('/report-symptom'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // ================= INFO SECTION =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Informasi TBC",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  InkWell(
                    borderRadius: BorderRadius.circular(8.r),
                    onTap: () => context.go('/news-patient'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 8.h,
                      ),
                      child: Text(
                        "LIHAT SEMUA",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: const Color(0xFF006D37),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              _newsPreview(),

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
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          decoration: BoxDecoration(
            gradient:
                isPrimary
                    ? const LinearGradient(
                      colors: [Color(0xFF27AE60), Color(0xFF006D37)],
                    )
                    : null,
            color: isPrimary ? null : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border:
                isPrimary ? null : Border.all(color: const Color(0xFFE8F8F1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color:
                      isPrimary
                          ? Colors.white.withValues(alpha: 0.2)
                          : const Color(0xFFD6E6DF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isPrimary ? Colors.white : const Color(0xFF596862),
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
                  color: isPrimary ? Colors.white : const Color(0xFF171D17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= ARTICLE CARD =================
  Widget _newsPreview() {
    return FutureBuilder<List<NewsApiArticle>>(
      future: _newsPreviewFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 260.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (context, index) => SizedBox(width: 16.w),
              itemBuilder: (context, index) => _articleLoadingCard(),
            ),
          );
        }

        if (snapshot.hasError || (snapshot.data ?? []).isEmpty) {
          return _newsMessageCard(
            title: 'Berita belum tersedia',
            subtitle: 'Buka halaman news untuk memuat ulang informasi TBC.',
          );
        }

        final articles = (snapshot.data ?? []).take(4).toList();

        return SizedBox(
          height: 260.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: articles.length,
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemBuilder:
                (context, index) => _articleCard(article: articles[index]),
          ),
        );
      },
    );
  }

  Widget _articleCard({required NewsApiArticle article}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => context.push('/patient-news-detail', extra: article),
        child: Ink(
          width: 260.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE8F8F1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 118.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE5DB),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 54.w,
                    height: 54.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.72),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _newsIcon(article.category),
                      size: 26.sp,
                      color: const Color(0xFF006D37),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: const Color(0xFF53615C),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.sp,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF171D17),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      article.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF3D4A3F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _articleLoadingCard() {
    return Container(
      width: 260.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8F8F1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 118.h,
            decoration: BoxDecoration(
              color: const Color(0xFFDDE5DB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _loadingLine(width: 92.w, height: 12.h),
                SizedBox(height: 12.h),
                _loadingLine(width: 196.w, height: 16.h),
                SizedBox(height: 8.h),
                _loadingLine(width: 160.w, height: 16.h),
                SizedBox(height: 12.h),
                _loadingLine(width: 80.w, height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _newsIcon(String category) {
    switch (category) {
      case 'Pengobatan':
        return Icons.medical_services_outlined;
      case 'Nutrisi':
        return Icons.restaurant_outlined;
      default:
        return Iconsax.health;
    }
  }

  Widget _loadingLine({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFDDE5DB),
        borderRadius: BorderRadius.circular(999.r),
      ),
    );
  }

  Widget _newsMessageCard({required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8F8F1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFF006D37).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.document_text, color: Color(0xFF006D37)),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF171D17),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.35,
                    color: const Color(0xFF3D4A3F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
