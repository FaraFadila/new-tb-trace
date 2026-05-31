import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi Rumah Pasien'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(-7.2575, 112.7521), // Pusat Surabaya
              initialZoom: 13,
              // Fungsi ini akan berjalan saat peta diketuk
              onTap: (tapPosition, point) {
                setState(() {
                  _pickedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.tugas.tbtrace',
              ),
              // Jika titik sudah dipilih, munculkan pin merah
              if (_pickedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _pickedLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          
          // Kotak Petunjuk di atas peta
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: const Text(
                'Ketuk pada peta untuk menancapkan pin lokasi rumah pasien.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      
      // Tombol Konfirmasi muncul di bawah hanya JIKA titik sudah dipilih
      floatingActionButton: _pickedLocation == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                // Membawa data koordinat kembali ke halaman Add Patient
                Navigator.pop(context, _pickedLocation);
              },
              backgroundColor: Colors.green,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text('Gunakan Lokasi Ini', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}