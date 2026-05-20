import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../core/widgets/app_user_header.dart';
import '../../core/widgets/healthcare_bottom_navbar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late List<KelurahanData> _mapData;
  late MapShapeSource _shapeSource;

  @override
  void initState() {
    super.initState();

    // 1. Data Dummy Kelurahan (Nantinya diganti dengan hasil ambil data dari tabel Supabase)
    _mapData = <KelurahanData>[
      const KelurahanData('Keputih', Color(0xFFBF0A0A)), // Risiko Tinggi (Merah)
      const KelurahanData('Gubeng', Color(0xFF878312)),  // Risiko Sedang (Kuning)
      const KelurahanData('Sukolilo', Color(0xFF4D7B4F)), // Aman (Hijau)
    ];

    // 2. Load file GeoJSON dari URL Supabase Storage kamu
    _shapeSource = MapShapeSource.network(
      'https://rvjrlbdjchdnzaxxmtwv.supabase.co/storage/v1/object/public/maps-data/kelurahan_surabaya.geojson',
      // Menggunakan 'name' karena data dari Overpass Turbo menggunakan key ini untuk nama daerah
      shapeDataField: 'name', 
      dataCount: _mapData.length,
      primaryValueMapper: (int index) => _mapData[index].nama,
      shapeColorValueMapper: (int index) => _mapData[index].warna.withOpacity(0.6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: const Color(0xFFF8FAFA),

      // ================= BOTTOM NAVBAR =================
      bottomNavigationBar: const HealthcareBottomNavbar(currentIndex: 1),

      body: Stack(
        children: [
          // ================= MAP SYNCFUSION =================
          SfMaps(
            layers: [
              // Layer 1: Peta Dasar (Jalan Raya & Batas Dunia dari OpenStreetMap)
              MapTileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                initialFocalLatLng: const MapLatLng(-7.2575, 112.7521), // Koordinat Pusat Surabaya
                initialZoomLevel: 12,
                
                // Kontrol Interaksi Zoom & Geser Peta
                zoomPanBehavior: MapZoomPanBehavior(
                  enableDoubleTapZooming: true,
                  enablePanning: true,
                  enablePinching: true,
                  zoomLevel: 12,
                ),

                // Layer 2: Poligon Warna Kelurahan (Ditumpuk di atas OpenStreetMap)
                sublayers: [
                  MapShapeSublayer(
                    source: _shapeSource,
                    strokeColor: const Color(0xFF006E1C).withOpacity(0.5),
                    strokeWidth: 1.0,
                    
                    // Memunculkan nama kelurahan saat di-tap/klik
                    shapeTooltipBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _mapData[index].nama,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // ================= LIVE BADGE =================
          Positioned(
            left: 24,
            top: 100,
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
                  ),
                ],
              ),
            ),
          ),

          // ================= MAP CONTROLS =================
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

          // ================= TOP APPBAR =================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: const AppUserHeader(
              horizontalPadding: 24,
              profileRoute: '/profile-healthcare',
            ),
          ),
        ],
      ),
    );
  }

  // ================= GLASS CONTAINER =================
  Widget _buildGlassContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
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
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // ================= MAP CONTROL BUTTON =================
  Widget _buildMapControlButton(IconData icon) {
    return _buildGlassContainer(
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: const Color(0xFF3F4A3C), size: 20),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

// ================= MODEL DATA (Opsi 1: Berada di luar class utama) =================
class KelurahanData {
  const KelurahanData(this.nama, this.warna);
  final String nama;
  final Color warna;
}