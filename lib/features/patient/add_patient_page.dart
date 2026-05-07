import 'package:flutter/material.dart';

class AddPatientPage extends StatelessWidget {
  const AddPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF047857),
            size: 18,
          ),
        ),

        title: const Text(
          "Tambahkan Pasien Baru",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // =========================
            // INFORMASI PASIEN
            // =========================
            const Row(
              children: [
                Icon(
                  Icons.people_outline,
                  color: Color(0xFF10B981),
                ),

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
                    label: "Nama Pasien",
                    hint: "Nama Lengkap",
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 20),

                  _buildInput(
                    label:
                        "Nomor Telepon Pribadi",
                    hint: "+62 0000-0000-000",
                    icon: Icons.phone_outlined,
                  ),

                  const SizedBox(height: 20),

                  _buildInput(
                    label: "Address",
                    hint:
                        "Alamat Jalan, Kota, kode pos",
                    icon:
                        Icons.location_on_outlined,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 20),

                  _buildInput(
                    label: "Nama Wali",
                    hint: "Nama Lengkap",
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 20),

                  _buildInput(
                    label:
                        "Nomor Telepon Wali",
                    hint: "+62 0000-0000-000",
                    icon: Icons.phone_outlined,
                  ),

                  const SizedBox(height: 20),

                  _buildInput(
                    label: "Address Wali",
                    hint:
                        "Alamat Jalan, Kota, kode pos",
                    icon:
                        Icons.location_on_outlined,
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
                Icon(
                  Icons.lock_outline,
                  color: Color(0xFF10B981),
                ),

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
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // USERNAME
                  const Text(
                    "Username (Auto-generated)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w500,
                      color: Color(0xFF4A5746),
                    ),
                  ),

                  const SizedBox(height: 8),

                  _generatedField(
                    text: "PT-849201",
                    icon: Icons.copy_outlined,
                  ),

                  const SizedBox(height: 24),

                  // PASSWORD
                  const Text(
                    "Temporary Password",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w500,
                      color: Color(0xFF4A5746),
                    ),
                  ),

                  const SizedBox(height: 8),

                  _generatedField(
                    text: "TempPass!23",
                    icon:
                        Icons.visibility_outlined,
                  ),

                  const SizedBox(height: 14),

                  const Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color:
                            Color(0xB3059669),
                      ),

                      SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          "Patient will be prompted to change this on first login.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(
                              0xB3059669,
                            ),
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
                onPressed: () {},

                style:
                    ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  backgroundColor:
                      Colors.transparent,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),

                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),

                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xFF006D37),
                        Color(0xFF27AE60),
                      ],
                    ),
                  ),

                  child: const Center(
                    child: Text(
                      "Simpan Pasien",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
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
  static Widget _glassCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color:
              Colors.white.withOpacity(0.5),
        ),

        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(
              16,
              185,
              129,
              0.05,
            ),
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
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
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
          maxLines: maxLines,

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
            ),

            prefixIcon: Icon(
              icon,
              color: const Color(
                0xFF34D399,
              ),
            ),

            filled: true,

            fillColor:
                Colors.white.withOpacity(
              0.6,
            ),

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),

              borderSide:
                  const BorderSide(
                color: Color(0xFFD1FAE5),
              ),
            ),

            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),

              borderSide:
                  const BorderSide(
                color: Color(0xFFD1FAE5),
              ),
            ),

            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),

              borderSide:
                  const BorderSide(
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
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(0.5),

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color: const Color(
            0xFFD1FAE5,
          ).withOpacity(0.5),
        ),
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w500,
                color: Color(0xFF064E3B),
              ),
            ),
          ),

          Icon(
            icon,
            color: const Color(
              0xFF059669,
            ),
          ),
        ],
      ),
    );
  }
}