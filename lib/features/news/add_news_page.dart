import 'package:flutter/material.dart';
import 'package:tb_trace/core/widgets/app_user_header.dart';

class TambahBeritaScreen extends StatefulWidget {
  const TambahBeritaScreen({super.key});

  @override
  State<TambahBeritaScreen> createState() => _TambahBeritaScreenState();
}

class _TambahBeritaScreenState extends State<TambahBeritaScreen> {
  bool isMedicalReview = false;
  String? selectedKategori = 'Pengobatan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background utama dari desain: #F4FBF1
      backgroundColor: const Color(0xFFF4FBF1),
      appBar: AppPageHeader(
        title: 'Tambah Berita',
        fallbackRoute: '/news-healthcare',
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Save Draft',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF059669),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        // Padding utama kiri-kanan 20px
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ROW 1: STATUS DRAFT & AUTHOR ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF53615C),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'STATUS: DRAFT',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: Color(0xFF53615C),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6EC),
                    border: Border.all(color: const Color(0xFFBCCABC)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Color(0xFF006D37),
                      ),
                      const SizedBox(width: 6),
                      CurrentUserNameText(
                        builder:
                            (context, displayName) => Text(
                              'Author: $displayName',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xFF171D17),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- INPUT: KATEGORI ---
            _buildLabel('Kategori'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedKategori,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF6B7280),
              ),
              decoration: _inputDecoration(),
              items:
                  ['Pengobatan', 'Pencegahan', 'Gaya Hidup']
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xFF171D17),
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (val) {
                setState(() => selectedKategori = val);
              },
            ),
            const SizedBox(height: 24),

            // --- INPUT: LOKASI ---
            _buildLabel('Lokasi'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: _inputDecoration(
                hintText: 'e.g. Central Hospital',
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF3D4A3F),
                  size: 20,
                ),
              ),
              style: const TextStyle(fontFamily: 'Inter', fontSize: 16),
            ),
            const SizedBox(height: 24),

            // --- INPUT: LINK BERITA ---
            _buildLabel('LINK BERITA / URL'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: _inputDecoration(
                hintText: 'https://...',
                prefixIcon: const Icon(
                  Icons.link,
                  color: Color(0xFF3D4A3F),
                  size: 20,
                ),
              ),
              style: const TextStyle(fontFamily: 'Inter', fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pasien akan dialihkan ke tautan ini ketika membaca.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Color(0xFF3D4A3F),
              ),
            ),
            const SizedBox(height: 32),

            // --- BOX: FEATURED IMAGE ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFBCCABC)),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'FEATURED IMAGE (OPTIONAL)',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 0.6,
                      color: Color(0xFF3D4A3F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 52),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6EC),
                      // Catatan: Flutter standar tidak punya dashed border bawaan.
                      // Untuk hasil persis putus-putus, bisa gunakan package 'dotted_border'
                      // Sementara saya gunakan solid border yang warnanya disamakan.
                      border: Border.all(
                        color: const Color(0xFFBCCABC),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          size: 32,
                          color: Color(0xFFBCCABC),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Upload JPG or PNG',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Color(0xFF6D7A6E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- BOX: MEDICAL REVIEW ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF006D37).withOpacity(0.05),
                border: Border.all(
                  color: const Color(0xFF006D37).withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                            color: Color(0xFF006D37),
                            size: 22,
                          ),
                          const SizedBox(height: 8, width: 8),
                          const Text(
                            'Medical Review',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF006D37),
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: isMedicalReview,
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFF006D37),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFFBCCABC),
                        onChanged: (val) {
                          setState(() {
                            isMedicalReview = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tandai sebagai terverifikasi agar artikel mendapat lencana 'Konten Terverifikasi' oleh medis.",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF3D4A3F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- BUTTON: KIRIM BERITA ---
            Center(
              child: Container(
                width: 205,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF006D37), Color(0xFF10B981)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF006D37).withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send, color: Colors.white, size: 18),
                        const SizedBox(width: 12),
                        const Text(
                          'Kirim Berita',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  // Fungsi pembuat label agar code tidak berulang
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 0.6,
        color: Color(0xFF3D4A3F),
      ),
    );
  }

  // Fungsi styling Input Box standar
  InputDecoration _inputDecoration({String? hintText, Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF6B7280)),
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBCCABC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF006D37), width: 1.5),
      ),
    );
  }
}
