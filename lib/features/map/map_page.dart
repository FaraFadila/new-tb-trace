import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/widgets/app_user_header.dart';
import '../../core/widgets/healthcare_bottom_navbar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> _kelurahanMarkers = [];
  List<dynamic> _listPasien = [];
  List<Polygon> _polygons = []; 
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _fetchAndGroupData();
  }

  Future<void> _fetchAndGroupData() async {
    // 1. AMBIL DATA PASIEN DARI SUPABASE
    final response = await Supabase.instance.client.from('patients').select();
    Map<String, List<dynamic>> dataPerKelurahan = {};

    for (var pasien in response) {
      String kelurahan = pasien['kelurahan'] ?? 'Lainnya'; 
      if (!dataPerKelurahan.containsKey(kelurahan)) {
        dataPerKelurahan[kelurahan] = [];
      }
      dataPerKelurahan[kelurahan]!.add(pasien);
    }

    // 2. BUAT PIN MARKER (Sama seperti sebelumnya)
    List<Marker> tempMarkers = [];
    dataPerKelurahan.forEach((namaKelurahan, listPasien) {
      int totalKasus = listPasien.length;
      Color pinColor = Colors.orange; 
      if (totalKasus >= 5) pinColor = Colors.red;

      double lat = listPasien[0]['latitude'] ?? 0.0;
      double lng = listPasien[0]['longitude'] ?? 0.0;

      tempMarkers.add(
        Marker(
          point: LatLng(lat, lng),
          width: 60.0,
          height: 60.0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque, 
            onTap: () => _tampilkanBottomSheet(namaKelurahan, totalKasus, listPasien),
            child: Container(
              width: 60.0,
              height: 60.0,
              alignment: Alignment.center,
              child: Icon(Icons.location_on, color: pinColor, size: 50.0),
            ),
          ),
        ),
      );
    });

    // 3. BACA GEOJSON & BUAT POLYGON ZONA WARNA
    List<Polygon> tempPolygons = [];
    try {
      // Buka file geojson. Pastikan path ini sesuai dengan letak folder assets-mu!
      final String geojsonString = await rootBundle.loadString('assets/maps/kelurahan_surabaya.geojson');
      final geojsonData = json.decode(geojsonString);

      for (var feature in geojsonData['features']) {
        // AMBIL NAMA KELURAHAN DARI GEOJSON 
        // (Bisa 'Kelurahan', 'NAME_4', atau 'NAMA_KEL' tergantung isi file geojson-mu)
        String namaKelurahanMap = feature['properties']['Kelurahan'] ?? feature['properties']['NAME_4'] ?? '';

        int totalKasusZona = 0;
        
        // Cari kelurahan ini di database Supabase (pakai toLowerCase biar gak error beda huruf besar/kecil)
        var dataKelurahanDb = dataPerKelurahan.entries.where((e) =>
            e.key.toLowerCase() == namaKelurahanMap.toLowerCase());

        if (dataKelurahanDb.isNotEmpty) {
          totalKasusZona = dataKelurahanDb.first.value.length;
        }

        // LOGIKA WARNA (Dinilai dari total pasien di kelurahan tersebut)
        Color zonaColor = Colors.green.withOpacity(0.3); // Default: Hijau (Aman / 0 Pasien)
        if (totalKasusZona >= 5) {
          zonaColor = Colors.red.withOpacity(0.4); // Bahaya: Merah (>= 5 Pasien)
        } else if (totalKasusZona > 0) {
          zonaColor = Colors.yellow.withOpacity(0.4); // Waspada: Kuning (1-4 Pasien)
        }

        // GAMBAR GARIS POLYGON-NYA
        var geometry = feature['geometry'];
        
        if (geometry['type'] == 'Polygon') {
          List<LatLng> points = [];
          for (var coord in geometry['coordinates'][0]) {
            points.add(LatLng(coord[1], coord[0]));
          }
          if (points.isNotEmpty) {
            tempPolygons.add(Polygon(
              points: points, color: zonaColor, borderColor: Colors.black, borderStrokeWidth: 1.0
            ));
          }
        }else if (geometry['type'] == 'MultiPolygon') {
          // Meloop semua bagian daratan agar tidak ada yang tertinggal
          for (var polyCoords in geometry['coordinates']) {
            List<LatLng> points = [];
            for (var coord in polyCoords[0]) {
              points.add(LatLng(coord[1], coord[0]));
            }
            if (points.isNotEmpty) {
              tempPolygons.add(Polygon(
                points: points, color: zonaColor, borderColor: Colors.black, borderStrokeWidth: 1.0
              ));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Gagal load GeoJSON: $e');
    }

    // 4. TAMPILKAN SEMUANYA KE LAYAR
    if (mounted) {
      setState(() {
        _kelurahanMarkers = tempMarkers;
        _polygons = tempPolygons; // Masukkan area warna ke peta
        _isLoading = false; // Matikan kaca pelindung loading
      });
    }
  }

  // Fungsi untuk memunculkan kartu putih dari bawah layar
  void _tampilkanBottomSheet(String kelurahan, int totalKasus, List<dynamic> listPasien) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, 
            children: [
              Text('Kelurahan $kelurahan', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(totalKasus >= 5 ? Icons.warning_rounded : Icons.info_outline, color: totalKasus >= 5 ? Colors.red : Colors.orange),
                  const SizedBox(width: 8),
                  Text('Total: $totalKasus Pasien Aktif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: totalKasus >= 5 ? Colors.red : Colors.orange)),
                ],
              ),
              const Divider(height: 25, thickness: 1.5),
              const Text('Daftar Pasien:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listPasien.length,
                  itemBuilder: (context, index) {
                    final pasien = listPasien[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.person, color: Colors.white, size: 20)),
                      title: Text(pasien['full_name'] ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(pasien['address'] ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  // FUNGSI MEMUNCULKAN KOTAK BAWAH (BOTTOM SHEET)
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const HealthcareBottomNavbar(currentIndex: 1),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-7.2575, 112.7521), 
              initialZoom: 12.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.tugas.tbtrace',
              ),
          
              PolygonLayer(polygons: _polygons),
              
              MarkerLayer(
                markers: _kelurahanMarkers, 
                // markers: _listPasien.map((p) => Marker(
                //   point: LatLng(
                //     (p['latitude'] as num).toDouble(), 
                //     (p['longitude'] as num).toDouble()
                //   ),
                //   width: 50,
                //   height: 50,
                //   child: GestureDetector(
                //     onTap: () {
                //       _showPatientDetail(p);
                //     },
                //     child: const Icon(Icons.location_on, color: Colors.red, size: 45),
                //   ),
                // )).toList(),
              ),
            ],
          ),
          const Positioned(
            top: 0, left: 0, right: 0,
            child: AppUserHeader(horizontalPadding: 24, profileRoute: '/profile-healthcare'),
          ),
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.6),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}