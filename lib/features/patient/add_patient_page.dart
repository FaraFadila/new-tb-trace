import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:tb_trace/core/services/patient_service.dart';
import 'package:tb_trace/core/widgets/app_user_header.dart';
import '../map/MapPickerPage.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final PatientService _patientService = PatientService();
  
  // Controller Bawaan Fara
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController(text: 'Surabaya');
  final TextEditingController guardianNameController = TextEditingController();
  final TextEditingController guardianPhoneController = TextEditingController();
  final TextEditingController guardianAddressController = TextEditingController();

  // Tambahan Manda (Peta, Kelurahan, Tanggal)
  final List<String> _daftarKelurahan = [
    'Airlangga', 'Alun-Alun Contong', 'Ampel', 'Babatan', 'Balas Klumprik', 'Baratajaya', 'Bendul Merisi', 'Beringin', 'Bongkaran', 'Bubutan', 'Darmo', 'Embong Kaliasin', 'Gayungan', 'Genteng', 'Gubeng', 'Jagir', 'Jemur Wonosari', 'Karang Pilang', 'Kebraon', 'Kedungdoro', 'Kedurus', 'Kemayoran', 'Keputih', 'Keputran', 'Kertajaya', 'Ketabang', 'Ketintang', 'Klampis Ngasem', 'Krembangan Selatan', 'Krembangan Utara', 'Lakarsantri', 'Lontar', 'Made', 'Margorejo', 'Medokan Ayu', 'Menur Pumpungan', 'Mojo', 'Ngagel', 'Ngagelrejo', 'Nginden Jangkungan', 'Nyamplungan', 'Pacar Keling', 'Pacar Kembang', 'Pegirian', 'Peneleh', 'Perak Barat', 'Perak Timur', 'Ploso', 'Pucang Sewu', 'Rangkah', 'Sambikerep', 'Sawunggaling', 'Semolowaru', 'Sidotopo', 'Tambaksari', 'Tegalsari', 'Wiyung', 'Wonokromo', 'Wonorejo'
  ];
  String? _selectedKelurahan;
  double? _selectedLatitude;
  double? _selectedLongitude;
  DateTime? _startDate;
  DateTime? _endDate;

  bool isLoading = false;
  CreatedPatientCredentials? createdCredentials;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    districtController.dispose();
    cityController.dispose();
    guardianNameController.dispose();
    guardianPhoneController.dispose();
    guardianAddressController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF10B981)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked;
        else _endDate = picked;
      });
    }
  }

  Future<void> _savePatient() async {
    if (isLoading) return;

    final fullName = nameController.text.trim();

    if (fullName.isEmpty || _selectedLatitude == null || _selectedKelurahan == null) {
      _showMessage('Nama, Kelurahan, dan Lokasi Peta wajib diisi!');
      return;
    }

    setState(() {
      isLoading = true;
      createdCredentials = null;
    });

    try {
      // PERHATIAN: Memanggil Service buatan Fara!
      await _patientService.createPatient(
        fullName: fullName,
        phone: _emptyToNull(phoneController.text),
        address: _emptyToNull(_patientAddress()),
        guardianName: _emptyToNull(guardianNameController.text),
        guardianPhone: _emptyToNull(guardianPhoneController.text),
        guardianAddress: _emptyToNull(guardianAddressController.text),
        
      
        kelurahan: _selectedKelurahan,
        latitude: _selectedLatitude,
        longitude: _selectedLongitude,
        treatmentStartDate: _startDate?.toIso8601String().split('T')[0],
        treatmentEndDate: _endDate?.toIso8601String().split('T')[0],
      );

      if (!mounted) return;

      _showMessage('Pasien berhasil dibuat dan credential tersimpan.');
      context.go('/patient-management');
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (e) {
      _showMessage('Gagal menyimpan pasien: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _patientAddress() {
    return [
      addressController.text,
      _selectedKelurahan ?? '',
      districtController.text,
      cityController.text,
      'Jawa Timur',
      'Indonesia',
    ].map((part) => part.trim()).where((part) => part.isNotEmpty).join(', ');
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),
      appBar: const AppPageHeader(
        title: 'Tambahkan Pasien Baru',
        centerTitle: true,
        fallbackRoute: '/patient-management',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INFORMASI PASIEN
            const Row(
              children: [
                Icon(Icons.people_outline, color: Color(0xFF10B981)),
                SizedBox(width: 8),
                Text("Informasi Pasien", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF065F46))),
              ],
            ),
            const SizedBox(height: 16),
            _glassCard(
              child: Column(
                children: [
                  _buildInput(controller: nameController, label: "Nama Pasien", hint: "Nama Lengkap", icon: Icons.person_outline),
                  const SizedBox(height: 20),
                  _buildInput(controller: phoneController, label: "Nomor Telepon Pribadi", hint: "+62 0000-0000-000", icon: Icons.phone_outlined),
                  const SizedBox(height: 20),
                  _buildInput(controller: addressController, label: "Alamat Jalan", hint: "Nama jalan, nomor rumah, RT/RW", icon: Icons.location_on_outlined, maxLines: 3),
                  const SizedBox(height: 20),
                  
                  // DROPDOWN KELURAHAN MANDA
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Kelurahan", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF4A5746))),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.location_city_outlined, color: Color(0xFF34D399)),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.6),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD1FAE5))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD1FAE5))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5)),
                        ),
                        value: _selectedKelurahan,
                        hint: const Text('Pilih Kelurahan', style: TextStyle(color: Color(0xFF94A3B8))),
                        items: _daftarKelurahan.map((String kelurahan) {
                          return DropdownMenuItem<String>(value: kelurahan, child: Text(kelurahan));
                        }).toList(),
                        onChanged: (String? nilaiBaru) => setState(() => _selectedKelurahan = nilaiBaru),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _buildInput(controller: districtController, label: "Kecamatan", hint: "Contoh: Sukolilo", icon: Icons.map_outlined),
                  const SizedBox(height: 20),
                  _buildInput(controller: cityController, label: "Kota", hint: "Contoh: Surabaya", icon: Icons.apartment_outlined),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // LOKASI & JADWAL (FITUR MANDA)
            const Row(
              children: [
                Icon(Icons.map_rounded, color: Color(0xFF10B981)),
                SizedBox(width: 8),
                Text("Lokasi & Jadwal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF065F46))),
              ],
            ),
            const SizedBox(height: 16),
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _pilihTanggal(context, true),
                    icon: const Icon(Icons.calendar_today, color: Color(0xFF10B981)),
                    label: Text(_startDate == null ? 'Mulai Pengobatan' : 'Mulai: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}', style: const TextStyle(color: Color(0xFF065F46))),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _pilihTanggal(context, false),
                    icon: const Icon(Icons.event_available, color: Color(0xFF10B981)),
                    label: Text(_endDate == null ? 'Selesai Pengobatan' : 'Selesai: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}', style: const TextStyle(color: Color(0xFF065F46))),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _selectedLatitude == null ? const Color(0xFF10B981) : Colors.green),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () async {
                        final LatLng? picked = await Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPickerPage()));
                        if (picked != null) {
                          setState(() {
                            _selectedLatitude = picked.latitude;
                            _selectedLongitude = picked.longitude;
                          });
                        }
                      },
                      icon: Icon(_selectedLatitude == null ? Icons.map : Icons.check_circle, color: _selectedLatitude == null ? const Color(0xFF10B981) : Colors.green),
                      label: Text(_selectedLatitude == null ? 'Pilih Titik Lokasi (Peta)' : 'Lokasi Terpilih (Ganti?)', style: TextStyle(color: _selectedLatitude == null ? const Color(0xFF065F46) : Colors.green)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // INFORMASI WALI
            const Row(
              children: [
                Icon(Icons.family_restroom, color: Color(0xFF10B981)),
                SizedBox(width: 8),
                Text("Informasi Wali", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF065F46))),
              ],
            ),
            const SizedBox(height: 16),
            _glassCard(
              child: Column(
                children: [
                  _buildInput(controller: guardianNameController, label: "Nama Wali", hint: "Nama Lengkap", icon: Icons.person_outline),
                  const SizedBox(height: 20),
                  _buildInput(controller: guardianPhoneController, label: "Nomor Telepon Wali", hint: "+62 0000-0000-000", icon: Icons.phone_outlined),
                  const SizedBox(height: 20),
                  _buildInput(controller: guardianAddressController, label: "Alamat Wali", hint: "Alamat Jalan, Kota, kode pos", icon: Icons.location_on_outlined, maxLines: 4),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // LOGIN CREDENTIALS
            const Row(
              children: [
                Icon(Icons.lock_outline, color: Color(0xFF10B981)),
                SizedBox(width: 8),
                Text("Login Credentials", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF065F46))),
              ],
            ),
            const SizedBox(height: 16),
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Username Pasien", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF4A5746))),
                  const SizedBox(height: 8),
                  _generatedField(text: createdCredentials?.username ?? "Akan dibuat setelah disimpan", icon: Icons.copy_outlined),
                  const SizedBox(height: 24),
                  const Text("Temporary Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF4A5746))),
                  const SizedBox(height: 8),
                  _generatedField(text: createdCredentials?.temporaryPassword ?? "Akan dibuat setelah disimpan", icon: Icons.visibility_outlined),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // BUTTON SIMPAN
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : _savePatient,
                style: ElevatedButton.styleFrom(
                  elevation: 0, padding: EdgeInsets.zero, backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(colors: [Color(0xFF006D37), Color(0xFF27AE60)]),
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text("Simpan Pasien", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // WIDGET BANTUAN FARA TETAP DIPERTAHANKAN DI SINI
  static Widget _glassCard({required Widget child}) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(16, 185, 129, 0.05), blurRadius: 32, offset: Offset(0, 8))],
      ),
      child: child,
    );
  }

  static Widget _buildInput({required TextEditingController controller, required String label, required String hint, required IconData icon, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF4A5746))),
        const SizedBox(height: 8),
        TextField(
          controller: controller, maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint, hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            prefixIcon: Icon(icon, color: const Color(0xFF34D399)),
            filled: true, fillColor: Colors.white.withValues(alpha: 0.6),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD1FAE5))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD1FAE5))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5)),
          ),
        ),
      ],
    );
  }

  static Widget _generatedField({required String text, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD1FAE5).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF064E3B)))),
          Icon(icon, color: const Color(0xFF059669)),
        ],
      ),
    );
  }
}