import 'package:flutter/material.dart';

import '../../core/widgets/app_user_header.dart';
import '../../core/widgets/healthcare_bottom_navbar.dart';
import 'package:tb_trace/features/profile/profile_sidebar.dart';
import 'package:tb_trace/features/patient/add_patient_page.dart';
import 'package:tb_trace/features/patient/update_patient_status_bottomsheet.dart';

class PatientPage extends StatelessWidget {
  const PatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const ProfileSidebar(),
      backgroundColor: const Color(0xFFF8FAFA),

      // =========================
      // APP BAR
      // =========================
      appBar: const AppUserHeader(profileRoute: '/profile-healthcare'),

      // =========================
      // BODY
      // =========================
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // TITLE
            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                "Manajemen Pasien",

                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),

            const SizedBox(height: 16),

            // SEARCH
            TextField(
              decoration: InputDecoration(
                hintText: "Cari Pasien...",

                prefixIcon: const Icon(Icons.search),

                filled: true,
                fillColor: Colors.white,

                contentPadding: const EdgeInsets.symmetric(vertical: 14),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: const BorderSide(color: Color(0xFFE1E3E3)),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: const BorderSide(color: Color(0xFFE1E3E3)),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // FILTER
            Row(
              children: [
                _filterChip("All Patients", true),

                const SizedBox(width: 8),

                _filterChip("High Risk", false),

                const SizedBox(width: 8),

                _filterChip("Update Terbaru", false),
              ],
            ),

            const SizedBox(height: 16),

            // LIST
            Expanded(
              child: ListView(
                children: const [
                  PatientCard(
                    name: "Jane Cooper",
                    id: "PT-8472",
                    risk: "High Risk",
                    progress: 0.50,
                    day: "45 of 90",
                    update: "Today",
                    riskColor: Color(0xFFBA1A1A),
                    riskBg: Color(0xFFFFDAD6),
                    leftColor: Color(0xFFBA1A1A),
                  ),

                  SizedBox(height: 16),

                  PatientCard(
                    name: "Robert Fox",
                    id: "PT-3921",
                    risk: "Medium Risk",
                    progress: 0.13,
                    day: "12 of 90",
                    update: "2 days ago",
                    riskColor: Color(0xFFEAB308),
                    riskBg: Color(0xFFFEF9C3),
                    leftColor: Color(0xFFEAB308),
                  ),

                  SizedBox(height: 16),

                  PatientCard(
                    name: "Esther Howard",
                    id: "PT-1049",
                    risk: "Low Risk",
                    progress: 0.94,
                    day: "85 of 90",
                    update: "1 week ago",
                    riskColor: Color(0xFF5DAC5B),
                    riskBg: Color(0xFFD9E6DA),
                    leftColor: Color(0xFF5DAC5B),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // =========================
      // FLOATING BUTTON
      // =========================
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          gradient: const LinearGradient(
            colors: [Color(0xFF006D37), Color(0xFF61DE8A)],
          ),

          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 109, 55, 0.3),

              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),

        child: FloatingActionButton(
          backgroundColor: Colors.transparent,

          elevation: 0,

          onPressed: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (context) => const AddPatientPage()),
            );
          },

          child: const Icon(Icons.add),
        ),
      ),

      // =========================
      // BOTTOM NAVBAR
      // =========================
      bottomNavigationBar: const HealthcareBottomNavbar(currentIndex: 3),
    );
  }

  // =========================
  // FILTER CHIP
  // =========================
  static Widget _filterChip(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),

      decoration: BoxDecoration(
        color: active ? const Color(0xFF4CAF50) : Colors.white,

        borderRadius: BorderRadius.circular(999),

        border: Border.all(
          color: active ? Colors.transparent : const Color(0xFFBECAB9),
        ),
      ),

      child: Text(
        text,

        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,

          color: active ? const Color(0xFF003C0B) : const Color(0xFF3F4A3C),
        ),
      ),
    );
  }
}

// =========================
// PATIENT CARD
// =========================
class PatientCard extends StatelessWidget {
  final String name;
  final String id;
  final String risk;
  final double progress;
  final String day;
  final String update;
  final Color riskColor;
  final Color riskBg;
  final Color leftColor;

  const PatientCard({
    super.key,
    required this.name,
    required this.id,
    required this.risk,
    required this.progress,
    required this.day,
    required this.update,
    required this.riskColor,
    required this.riskBg,
    required this.leftColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 182,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFF2F4F4)),

        boxShadow: const [
          BoxShadow(blurRadius: 20, color: Color.fromRGBO(0, 0, 0, 0.04)),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 4,

            margin: const EdgeInsets.symmetric(vertical: 1),

            decoration: BoxDecoration(
              color: leftColor,

              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const CircleAvatar(
                        radius: 24,

                        backgroundImage: AssetImage(
                          "assets/images/profile.png",
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              name,

                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            Text(
                              "ID: $id",

                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF3F4A3C),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: riskBg,

                          borderRadius: BorderRadius.circular(999),
                        ),

                        child: Row(
                          children: [
                            CircleAvatar(radius: 3, backgroundColor: riskColor),

                            const SizedBox(width: 6),

                            Text(
                              risk,

                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,

                                color: riskColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Proses Pengobatan",

                        style: TextStyle(fontSize: 14),
                      ),

                      Text(
                        "Day $day",

                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),

                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,

                      backgroundColor: const Color(0xFFD9E6DA),

                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF006E1C),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,

                            size: 14,

                            color: Color(0xFF3F4A3C),
                          ),

                          const SizedBox(width: 4),

                          Text(
                            "Last updated: $update",

                            style: const TextStyle(
                              fontSize: 14,

                              color: Color(0xFF3F4A3C),
                            ),
                          ),
                        ],
                      ),

                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,

                            isScrollControlled: true,

                            backgroundColor: Colors.transparent,

                            builder: (context) {
                              return const UpdatePatientStatusBottomSheet();
                            },
                          );
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: const Color(0xFFECEEEE),

                            borderRadius: BorderRadius.circular(8),
                          ),

                          child: Row(
                            children: const [
                              Icon(
                                Icons.edit,

                                size: 12,

                                color: Color(0xFF006E1C),
                              ),

                              SizedBox(width: 6),

                              Text(
                                "Update",

                                style: TextStyle(
                                  fontSize: 12,

                                  fontWeight: FontWeight.w700,

                                  color: Color(0xFF006E1C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
