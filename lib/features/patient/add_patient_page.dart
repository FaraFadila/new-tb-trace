import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../map/MapPickerPage.dart'; // Pastikan ini tetap ada
import '../../core/widgets/app_user_header.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  // 1. Variabel penampung form (Lama + Baru)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _guardianNameController = TextEditingController();
  final TextEditingController _guardianPhoneController = TextEditingController();
  final TextEditingController _guardianAddressController = TextEditingController(); // Pastikan ada kolom guardian_address di DB
  // Daftar kelurahan untuk demo (Otomatis urut abjad A-Z)
  final List<String> _daftarKelurahan = [
    // Surabaya Pusat
    'Ketabang', 'Genteng', 'Embong Kaliasin', 'Keputran', 'Tegalsari', 'Kedungdoro', 'Wonorejo', 'Bubutan', 'Alun-Alun Contong', 'Peneleh',
    
    // Surabaya Timur 
    'Baratajaya', 'Gubeng', 'Airlangga', 'Kertajaya', 'Mojo', 'Pucang Sewu', 'Pacar Keling', 'Tambaksari', 'Pacar Kembang', 'Ploso', 'Rangkah', 'Keputih', 'Klampis Ngasem', 'Menur Pumpungan', 'Nginden Jangkungan', 'Semolowaru', 'Medokan Ayu',
    
    // Surabaya Selatan
    'Wonokromo', 'Darmo', 'Jagir', 'Ngagel', 'Ngagelrejo', 'Sawunggaling', 'Jemur Wonosari', 'Margorejo', 'Bendul Merisi', 'Ketintang', 'Gayungan',
    
    // Surabaya Barat
    'Kebraon', 'Karang Pilang', 'Kedurus', 'Wiyung', 'Babatan', 'Balas Klumprik', 'Lontar', 'Sambikerep', 'Beringin', 'Made', 'Lakarsantri',
    
    // Surabaya Utara
    'Krembangan Selatan', 'Krembangan Utara', 'Kemayoran', 'Perak Barat', 'Perak Timur', 'Bongkaran', 'Nyamplungan', 'Ampel', 'Pegirian', 'Sidotopo'
  ]..sort();
  // 2. Variabel penampung koordinat & tanggal
  double? _selectedLatitude;
  double? _selectedLongitude;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedKelurahan;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    _guardianAddressController.dispose();
    super.dispose();
  }

  // Fungsi pembuat password otomatis
  String _generateRandomPassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  // Fungsi pemilih kalender
  Future<void> _pilihTanggal(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green, // Warna kalender disesuaikan tema app
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Fungsi simpan data
  Future<void> _simpanDataPasien() async {
    // 1. Validasi Input Dasar
    if (_nameController.text.isEmpty || _selectedLatitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi Nama Pasien dan Pilih Lokasi di Peta!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Generate Kode Pasien Otomatis
      final randomNum = Random().nextInt(900000) + 100000;
      String generatedPatientCode = "PT-$randomNum";
      
      // Ambil ID dokter yang sedang login
      final currentHealthcareId = Supabase.instance.client.auth.currentUser?.id;

      // 3. INSERT LANGSUNG KE DATABASE
      await Supabase.instance.client.from('patients').insert({
        'healthcare_id': currentHealthcareId,
        'patient_code': generatedPatientCode,
        'full_name': _nameController.text,
        'kelurahan': _selectedKelurahan,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'guardian_name': _guardianNameController.text,
        'guardian_phone': _guardianPhoneController.text,
        'guardian_address': _guardianAddressController.text,
        'treatment_start_date': _startDate?.toIso8601String().split('T')[0],
        'treatment_end_date': _endDate?.toIso8601String().split('T')[0],
        'latitude': _selectedLatitude,
        'longitude': _selectedLongitude,
      });

      // 4. Sukses dan Kembali ke Halaman Sebelumnya
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sip! Data Pasien Berhasil Disimpan ke Database!')),
        );
        Navigator.pop(context); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Waduh gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pasien Baru'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Informasi Pasien', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Lengkap Pasien', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Nomor Telepon Pasien', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _addressController, maxLines: 2, decoration: const InputDecoration(labelText: 'Alamat Pasien', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Pilih Kelurahan',
                border: OutlineInputBorder(),
              ),
              value: _selectedKelurahan,
              hint: const Text('Pilih Kelurahan Pasien'),
              items: _daftarKelurahan.map((String kelurahan) {
                return DropdownMenuItem<String>(
                  value: kelurahan,
                  child: Text(kelurahan),
                );
              }).toList(),
              onChanged: (String? nilaiBaru) {
                setState(() {
                  _selectedKelurahan = nilaiBaru;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kelurahan wajib dipilih!';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),
            const Text('Informasi Wali', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: _guardianNameController, decoration: const InputDecoration(labelText: 'Nama Wali/Pendamping', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _guardianPhoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Nomor Telepon Wali', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _guardianAddressController, maxLines: 2, decoration: const InputDecoration(labelText: 'Alamat Wali', border: OutlineInputBorder())),
            
            const SizedBox(height: 24),
            const Text('Jadwal Pengobatan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Tombol Pilih Tanggal Mulai
            OutlinedButton.icon(
              onPressed: () => _pilihTanggal(context, true),
              icon: const Icon(Icons.calendar_today, color: Colors.blue),
              label: Text(_startDate == null ? 'Pilih Tanggal Mulai Pengobatan' : 'Mulai: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'),
            ),
            const SizedBox(height: 12),
            
            // Tombol Pilih Tanggal Selesai
            OutlinedButton.icon(
              onPressed: () => _pilihTanggal(context, false),
              icon: const Icon(Icons.event_available, color: Colors.blue),
              label: Text(_endDate == null ? 'Pilih Tanggal Selesai Pengobatan' : 'Selesai: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'),
            ),

            const SizedBox(height: 24),
            const Text('Lokasi Tempat Tinggal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final LatLng? picked = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapPickerPage()),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedLatitude = picked.latitude;
                      _selectedLongitude = picked.longitude;
                    });
                  }
                },
                icon: Icon(
                  _selectedLatitude == null ? Icons.map : Icons.check_circle, 
                  color: _selectedLatitude == null ? Colors.blue : Colors.green,
                ),
                label: Text(
                  _selectedLatitude == null ? 'Pilih Titik Lokasi Rumah (Peta)' : 'Lokasi Berhasil Dipilih (Ganti?)',
                  style: TextStyle(color: _selectedLatitude == null ? Colors.blue : Colors.green),
                ),
              ),
            ),
            
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _isLoading ? null : _simpanDataPasien,
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Data Pasien', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}