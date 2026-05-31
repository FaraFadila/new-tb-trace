import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/widgets/app_user_header.dart';
import '../../core/widgets/healthcare_bottom_navbar.dart';

class HealthcareNewsArticle {
  const HealthcareNewsArticle({
    required this.category,
    required this.title,
    required this.summary,
    required this.author,
    required this.location,
    required this.verifiedBy,
    this.sourceUrl,
    this.publishedAt = 'Today',
    this.readTime = '5 min read',
  });

  final String category;
  final String title;
  final String summary;
  final String author;
  final String location;
  final String verifiedBy;
  final String? sourceUrl;
  final String publishedAt;
  final String readTime;

  // 🟢 TAMBAHKAN INI: Fungsi untuk mengubah data dari Supabase (Map) menjadi Objek Model
  factory HealthcareNewsArticle.fromSupabase(Map<String, dynamic> json) {
    return HealthcareNewsArticle(
      category: json['category'] ?? 'Umum',
      title: json['title'] ?? 'Tanpa Judul',
      summary: json['summary'] ?? (json['content'] ?? 'Tidak ada ringkasan klinis ketersediaan artikel.'),
      // Jika relasi nama author belum di-select, kita pasang fallback string dulu
      author: json['profiles'] != null ? json['profiles']['full_name'] ?? 'Tim Medis' : 'Dokter Spesialis',
      location: json['location'] ?? 'Fasilitas Kesehatan',
      verifiedBy: json['is_medical_review'] == true ? 'Terverifikasi Medis' : 'Dalam Peninjauan',
      sourceUrl: json['source_url'],
      publishedAt: json['created_at'] != null 
          ? json['created_at'].toString().substring(0, 10) // Ambil tanggal YYYY-MM-DD
          : 'Today',
      readTime: '5 min read',
    );
  }
}

class HealthcareNewsDetailPage extends StatelessWidget {
  const HealthcareNewsDetailPage({super.key, this.article});

  final HealthcareNewsArticle? article;

  static const HealthcareNewsArticle fallbackArticle = HealthcareNewsArticle(
    category: 'Pencegahan',
    title: 'New Protocol for MDR-TB Showing 85% Efficacy in Early Trials',
    summary:
        'Recent clinical trials suggest that combining Bedaquiline with a novel compound shows improved clearance rates in multidrug-resistant TB cases.',
    author: 'Dr. Sarah Chen',
    location: 'WHO Office',
    verifiedBy: 'Dr. Zoro',
  );

  @override
  Widget build(BuildContext context) {
    final news = article ?? fallbackArticle;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF1),
      appBar: const AppPageHeader(
        title: 'Detail Berita',
        fallbackRoute: '/news-healthcare',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Tag(label: news.category),
                const Spacer(),
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: news.verifiedBy == 'Dalam Peninjauan' 
                      ? const Color(0xFF6B7280) 
                      : const Color(0xFF006D37),
                ),
                SizedBox(width: 6.w),
                Text(
                  news.verifiedBy == 'Dalam Peninjauan' ? 'Pending Review' : 'Verified',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: news.verifiedBy == 'Dalam Peninjauan' 
                        ? const Color(0xFF6B7280) 
                        : const Color(0xFF006D37),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Text(
              news.title,
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w800,
                height: 1.25,
                color: const Color(0xFF171D17),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              news.summary,
              style: TextStyle(
                fontSize: 15.sp,
                height: 1.55,
                color: const Color(0xFF3D4A3F),
              ),
            ),
            SizedBox(height: 18.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFBCCABC)),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  _MetaRow(
                    icon: Icons.person_outline,
                    label: 'Author',
                    value: news.author,
                  ),
                  const Divider(height: 24, color: Color(0xFFDDE5DB)),
                  _MetaRow(
                    icon: Icons.location_on_outlined,
                    label: 'Source',
                    value: news.location,
                  ),
                  const Divider(height: 24, color: Color(0xFFDDE5DB)),
                  _MetaRow(
                    icon: Icons.verified_outlined,
                    label: 'Medical review',
                    value: news.verifiedBy,
                  ),
                ],
              ),
            ),
            SizedBox(height: 22.h),
            _Section(
              title: 'Ringkasan Klinis',
              body:
                  'Artikel ini dapat digunakan tenaga kesehatan sebagai bahan edukasi pasien tentang pencegahan, kepatuhan pengobatan, dan pemantauan gejala TBC. Informasi di dalamnya perlu disesuaikan dengan kondisi klinis pasien dan protokol fasilitas kesehatan.',
            ),
            SizedBox(height: 18.h),
            _Section(
              title: 'Catatan untuk Dokter',
              body:
                  'Pastikan pasien memahami durasi terapi, jadwal kontrol, efek samping obat yang perlu dilaporkan, serta pentingnya menyelesaikan pengobatan. Untuk kasus risiko tinggi, lakukan pemantauan kontak erat dan dokumentasikan perkembangan pasien secara berkala.',
            ),
            SizedBox(height: 18.h),
            _Section(
              title: 'Status Publikasi',
              body:
                  'Dipublikasikan ${news.publishedAt} oleh ${news.author}. Estimasi waktu baca ${news.readTime}.',
            ),
            SizedBox(height: 24.h), // Jarak tambahan sebelum tombol
            if (news.sourceUrl != null && news.sourceUrl!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006D37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: const Icon(Icons.open_in_new, color: Colors.white, size: 20),
                  label: const Text(
                    'Baca Artikel Asli',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () async {
                    final Uri url = Uri.parse(news.sourceUrl!);
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal membuka link artikel')),
                        );
                      }
                    }
                  },
                ),
              ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
      bottomNavigationBar: const HealthcareBottomNavbar(currentIndex: 2),
    );
  }
}

// --- WIDGET PENDUKUNG tetep sama seperti codingan awalmu ---
class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
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
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
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
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1ECE5)),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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