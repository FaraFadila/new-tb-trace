import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tb_trace/core/services/patient_service.dart';
import 'package:tb_trace/core/widgets/app_user_header.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final PatientService _patientService = PatientService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController guardianNameController = TextEditingController();
  final TextEditingController guardianPhoneController = TextEditingController();
  final TextEditingController guardianAddressController =
      TextEditingController();

  bool isLoading = false;
  CreatedPatientCredentials? createdCredentials;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    guardianNameController.dispose();
    guardianPhoneController.dispose();
    guardianAddressController.dispose();
    super.dispose();
  }

  Future<void> _savePatient() async {
    final fullName = nameController.text.trim();

    if (fullName.isEmpty) {
      _showMessage('Nama pasien wajib diisi.');
      return;
    }

    setState(() {
      isLoading = true;
      createdCredentials = null;
    });

    try {
      await _patientService.createPatient(
        fullName: fullName,
        phone: _emptyToNull(phoneController.text),
        address: _emptyToNull(addressController.text),
        guardianName: _emptyToNull(guardianNameController.text),
        guardianPhone: _emptyToNull(guardianPhoneController.text),
        guardianAddress: _emptyToNull(guardianAddressController.text),
      );

      if (!mounted) return;

      _showMessage('Pasien berhasil dibuat dan credential tersimpan.');
      context.go('/patient-management');
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('Gagal menyimpan pasien. Periksa koneksi internet kamu.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),

      // APPBAR
      appBar: const AppPageHeader(
        title: 'Tambahkan Pasien Baru',
        centerTitle: true,
        fallbackRoute: '/patient-management',
      ),

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // INFORMASI PASIEN
            // =========================
            const Row(
              children: [
                Icon(Icons.people_outline, color: Color(0xFF10B981)),

                SizedBox(width: 8),

                Text(
                  "Informasi Pasien",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF065F46),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _glassCard(
              child: Column(
                children: [
                  _buildInput(
                    controller: nameController,
                    label: "Nama Pasien",
                    hint: "Nama Lengkap",
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 20),

                  _buildInput(
                    controller: phoneController,
                    label: "Nomor Telepon Pribadi",
                    hint: "+62 0000-0000-000",
                    icon: Icons.phone_outlined,
                  ),

                  const SizedBox(height: 20),

                  _buildInput(
                    controller: addressController,
                    label: "Address",
                    hint: "Alamat Jalan, Kota, kode pos",
                    icon: Icons.location_on_outlined,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 20),

                  _buildInput(
                    controller: guardianNameController,
                    label: "Nama Wali",
                    hint: "Nama Lengkap",
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 20),

                  _buildInput(
                    controller: guardianPhoneController,
                    label: "Nomor Telepon Wali",
                    hint: "+62 0000-0000-000",
                    icon: Icons.phone_outlined,
                  ),

                  const SizedBox(height: 20),

                  _buildInput(
                    controller: guardianAddressController,
                    label: "Address Wali",
                    hint: "Alamat Jalan, Kota, kode pos",
                    icon: Icons.location_on_outlined,
                    maxLines: 4,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =========================
            // LOGIN CREDENTIALS
            // =========================
            const Row(
              children: [
                Icon(Icons.lock_outline, color: Color(0xFF10B981)),

                SizedBox(width: 8),

                Text(
                  "Login Credentials",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF065F46),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // USERNAME
                  const Text(
                    "Username Pasien (Auto-generated)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A5746),
                    ),
                  ),

                  const SizedBox(height: 8),

                  _generatedField(
                    text:
                        createdCredentials?.username ??
                        "Akan dibuat setelah pasien disimpan",
                    icon: Icons.copy_outlined,
                  ),

                  const SizedBox(height: 24),

                  // PASSWORD
                  const Text(
                    "Temporary Password",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A5746),
                    ),
                  ),

                  const SizedBox(height: 8),

                  _generatedField(
                    text:
                        createdCredentials?.temporaryPassword ??
                        "Akan dibuat setelah pasien disimpan",
                    icon: Icons.visibility_outlined,
                  ),

                  if (createdCredentials != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      "Login Email Pasien",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4A5746),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _generatedField(
                      text: createdCredentials!.email,
                      icon: Icons.email_outlined,
                    ),
                  ],

                  const SizedBox(height: 14),

                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Color(0xB3059669),
                      ),

                      SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          "Patient will be prompted to change this on first login.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xB3059669),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: () {
                  if (!isLoading) {
                    _savePatient();
                  }
                },

                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),

                    gradient: const LinearGradient(
                      colors: [Color(0xFF006D37), Color(0xFF27AE60)],
                    ),
                  ),

                  child: Center(
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              "Simpan Pasien",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
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

  // =========================
  // GLASS CARD
  // =========================
  static Widget _glassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: Colors.white.withOpacity(0.5)),

        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 185, 129, 0.05),
            blurRadius: 32,
            offset: Offset(0, 8),
          ),
        ],
      ),

      child: child,
    );
  }

  // =========================
  // INPUT FIELD
  // =========================
  static Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A5746),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          maxLines: maxLines,

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),

            prefixIcon: Icon(icon, color: const Color(0xFF34D399)),

            filled: true,

            fillColor: Colors.white.withOpacity(0.6),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),

              borderSide: const BorderSide(color: Color(0xFFD1FAE5)),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),

              borderSide: const BorderSide(color: Color(0xFFD1FAE5)),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),

              borderSide: const BorderSide(
                color: Color(0xFF10B981),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // GENERATED FIELD
  // =========================
  static Widget _generatedField({
    required String text,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFD1FAE5).withOpacity(0.5)),
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF064E3B),
              ),
            ),
          ),

          Icon(icon, color: const Color(0xFF059669)),
        ],
      ),
    );
  }
}
