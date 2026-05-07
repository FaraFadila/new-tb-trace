import 'dart:ui';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _selectedIndex = 1; // Index 1 karena kita sedang di halaman "Map"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. LAYER PALING BAWAH: Background Peta & Heatmap
          // Nanti ini bisa kamu ganti pakai widget GoogleMap atau flutter_map
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFA),
              // TODO: Ganti dengan asset peta aslimu atau implementasi peta interaktif
              image: DecorationImage(
                image: AssetImage('assets/images/map_placeholder.png'), // Sesuaikan path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay Tint Hijau Tipis (sesuai spesifikasi CSS)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF064E3B).withOpacity(0.05),
          ),

          // 2. LAYER MARKER PETA (Pin Merah, Kuning, Hijau)
          // Catatan: Ini hardcode posisi pakai Positioned. Kalau pakai peta asli, gunakan properti Marker.
          Positioned(
            left: 68,
            top: 375,
            child: _buildMapPin(const Color(0xFFBF0A0A)), // Merah
          ),
          Positioned(
            right: 80,
            top: 425,
            child: _buildMapPin(const Color(0xFF878312)), // Kuning
          ),
          Positioned(
            left: 121,
            top: 682,
            child: _buildMapPin(const Color(0xFF4D7B4F)), // Hijau
          ),

          // 3. LAYER BADGE "Langsung"
          Positioned(
            left: 24,
            top: 100, // Disesuaikan agar di bawah Appbar
            child: _buildGlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF006E1C),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Langsung",
                    style: TextStyle(
                      color: Color(0xFF006E1C),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),

          // 4. LAYER KONTROL PETA (Zoom In, Zoom Out, Locate)
          Positioned(
            right: 24,
            top: 100,
            child: Column(
              children: [
                _buildMapControlButton(Icons.add),
                const SizedBox(height: 8),
                _buildMapControlButton(Icons.remove),
                const SizedBox(height: 8),
                _buildMapControlButton(Icons.my_location),
              ],
            ),
          ),

          // 5. LAYER TOP APP BAR (Kustom karena desainnya floating & blur)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 12, left: 24, right: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    border: const Border(bottom: BorderSide(color: Color(0xFFD1FAE5))),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_none, color: Color(0xFF1C274C)),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text("Hello,", style: TextStyle(fontSize: 12, color: Colors.black54)),
                          Text("Jade West", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const CircleAvatar(
                        backgroundColor: Color(0xFFEEF2F3),
                        radius: 20,
                        // TODO: Ganti dengan Image.asset atau NetworkImage foto profil
                        child: Icon(Icons.person, color: Colors.grey), 
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // 6. BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF006E1C),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            // TODO: Tambahkan navigasi routing ke halaman lain di sini
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "News"),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: "Patients"),
        ],
      ),
    );
  }

  // --- WIDGET HELPER --- //

  // Fungsi untuk membuat kotak dengan efek Glassmorphism (Kaca)
  Widget _buildGlassContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // Fungsi khusus untuk tombol kontrol peta (+, -, target)
  Widget _buildMapControlButton(IconData icon) {
    return _buildGlassContainer(
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF3F4A3C), size: 20),
        onPressed: () {}, // Isi fungsi kontrol peta di sini
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  // Fungsi pembangun Pin Map
  Widget _buildMapPin(Color color) {
    return Container(
      width: 28,
      height: 35,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))
        ]
      ),
      child: const Center(
        child: Icon(Icons.circle, color: Colors.white, size: 8),
      ),
    );
  }
}