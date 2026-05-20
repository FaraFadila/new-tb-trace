import 'package:flutter/material.dart';

import '../../core/widgets/patient_bottom_navbar.dart';
import '../../features/auth/login_page.dart';
import 'edit_profile_page.dart';
import 'profile_sidebar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ProfileSidebar(),

      backgroundColor: const Color(0xFFF4FBF1),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },

              icon: const Icon(
                Icons.menu,
                color: Color(0xFF171D17),
              ),
            );
          },
        ),

        centerTitle: true,

        title: const Text(
          "Profile",

          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF006D37),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 10,
        ),

        child: Column(
          children: [
            const SizedBox(height: 10),

            // ================= PROFILE IMAGE =================
            Container(
              width: 130,
              height: 130,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: const Color(0xFF006D37),
                  width: 3,
                ),

                image: const DecorationImage(
                  image: AssetImage(
                    "assets/images/profile.png",
                  ),
                  fit: BoxFit.cover,
                ),

                boxShadow: [
                  BoxShadow(
                    blurRadius: 14,
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= NAME =================
            const Text(
              "Larry Davis",

              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF171D17),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "melpeters@gmail.com",

              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF53615C),
              ),
            ),

            const SizedBox(height: 30),

            // ================= EDIT BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          const EditProfilePage(),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  elevation: 0,

                  backgroundColor:
                      const Color(0xFF006D37),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  "Edit Profile",

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ================= INFO CARD =================
            _infoCard(
              icon: Icons.location_on_outlined,
              title: "Current Location",
              value: "Surabaya",
            ),

            _infoCard(
              icon: Icons.warning_amber_rounded,
              title: "Risk Zone",
              value: "Low Risk",
            ),

            _infoCard(
              icon: Icons.medical_services_outlined,
              title: "Health Status",
              value: "Healthy",
            ),

            _infoCard(
              icon: Icons.calendar_month_outlined,
              title: "Last Checkup",
              value: "12 May 2026",
            ),

            const SizedBox(height: 24),

            // ================= LOGOUT BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 54,

              child: OutlinedButton(
                onPressed: () async {
                  try {
                    // 1. Proses sign out dari Supabase
                    await Supabase.instance.client.auth.signOut();
                    
                    // 2. Cek apakah widget masih aktif sebelum pindah halaman (Best Practice Flutter)
                    if (!context.mounted) return;

                    // 3. Arahkan kembali ke halaman Login dan hapus semua history halaman sebelumnya
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        // Ganti 'LoginPage()' dengan nama class halaman login/auth kamu yang sebenarnya
                        builder: (context) => const LoginPage(), 
                      ),
                      (route) => false, // false berarti semua tumpukan routing sebelumnya dihapus
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    // Tampilkan pesan error jika terjadi kegagalan jaringan/sistem
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal log out: $e")),
                    );
                  }
                },


                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFF006D37),
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  "Log Out",

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF006D37),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // ================= BOTTOM NAVBAR =================
      bottomNavigationBar:
          const PatientBottomNavbar(
        currentIndex: 3,
      ),
    );
  }

  // ================= INFO CARD =================
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0xFFE8F8F1),
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color:
                Colors.black.withOpacity(0.03),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: const Color(
                0xFF006D37,
              ).withOpacity(0.1),

              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: const Color(0xFF006D37),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF53615C),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF171D17),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}