import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tb_trace/core/services/news_api_service.dart';

import '../../core/widgets/app_user_header.dart';
import '../../core/widgets/patient_bottom_navbar.dart';

class PatientNewsDetailPage extends StatelessWidget {
  const PatientNewsDetailPage({super.key, this.article});

  final NewsApiArticle? article;

  static const NewsApiArticle fallbackArticle = NewsApiArticle(
    id: 'fallback',
    category: 'Pencegahan',
    title: 'Berita TBC',
    summary:
        'Informasi terbaru tentang tuberkulosis dari sumber kesehatan publik akan ditampilkan di halaman ini.',
    author: 'WHO',
    source: 'WHO',
    verifiedBy: 'WHO',
    publishedAt: 'Recently',
    sourceUrl: 'https://www.who.int/health-topics/tuberculosis',
  );

  @override
  Widget build(BuildContext context) {
    final news = article ?? fallbackArticle;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      appBar: const AppPageHeader(
        title: 'Detail Berita',
        fallbackRoute: '/news-patient',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tag(news.category),
            SizedBox(height: 18.h),
            Text(
              news.title,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                height: 1.25,
                color: const Color(0xFF171D17),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              news.summary,
              style: TextStyle(
                fontSize: 15.sp,
                height: 1.55,
                color: const Color(0xFF3D4A3F),
              ),
            ),
            SizedBox(height: 20.h),
            _metaCard(news),
            SizedBox(height: 20.h),
            _section(
              title: 'Catatan untuk Pasien',
              body:
                  'Gunakan informasi ini sebagai edukasi umum. Untuk keputusan pengobatan, jadwal kontrol, atau efek samping obat, tetap ikuti arahan dokter atau tenaga kesehatan.',
            ),
            SizedBox(height: 18.h),
            _section(
              title: 'Sumber',
              body:
                  'Artikel ini diambil dari ${news.source}. Tanggal publikasi: ${news.publishedAt}.',
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
      bottomNavigationBar: const PatientBottomNavbar(currentIndex: 2),
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFD6E6DF),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF596862),
        ),
      ),
    );
  }

  Widget _metaCard(NewsApiArticle news) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDE5DB)),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          _metaRow(
            icon: Icons.public_rounded,
            label: 'Sumber',
            value: news.source,
          ),
          const Divider(height: 24, color: Color(0xFFDDE5DB)),
          _metaRow(
            icon: Icons.calendar_today_outlined,
            label: 'Publikasi',
            value: news.publishedAt,
          ),
          const Divider(height: 24, color: Color(0xFFDDE5DB)),
          _metaRow(
            icon: Icons.verified_outlined,
            label: 'Verified source',
            value: news.verifiedBy,
          ),
        ],
      ),
    );
  }

  Widget _metaRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: const Color(0xFF006D37)),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF596862),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF171D17),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _section({required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1ECE5)),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF171D17),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            body,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.55,
              color: const Color(0xFF3D4A3F),
            ),
          ),
        ],
      ),
    );
  }
}
