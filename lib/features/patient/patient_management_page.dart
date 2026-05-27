import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tb_trace/core/services/patient_service.dart';
import 'package:tb_trace/core/widgets/app_user_header.dart';
import 'package:tb_trace/core/widgets/healthcare_bottom_navbar.dart';

enum _PatientFilter { all, highRisk, recentUpdate }

class PatientManagementPage extends StatefulWidget {
  const PatientManagementPage({super.key});

  @override
  State<PatientManagementPage> createState() => _PatientManagementPageState();
}

class _PatientManagementPageState extends State<PatientManagementPage> {
  final PatientService _patientService = PatientService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<PatientSummary>> _patientsFuture;
  _PatientFilter _selectedFilter = _PatientFilter.all;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _patientsFuture = _patientService.listPatients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshPatients() async {
    setState(() {
      _patientsFuture = _patientService.listPatients();
    });

    await _patientsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-patient');
        },

        elevation: 10,

        backgroundColor: const Color(0xFF006D37),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),

        child: const Icon(Icons.add, color: Colors.white),
      ),

      bottomNavigationBar: const HealthcareBottomNavbar(currentIndex: 3),

      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            const AppUserHeader(
              includeSafeArea: false,
              profileRoute: '/profile-healthcare',
            ),

            // ================= BODY =================
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshPatients,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // ================= TITLE =================
                      Text(
                        "Manajemen Pasien",

                        style: TextStyle(
                          fontSize: 34.sp,

                          fontWeight: FontWeight.w700,

                          color: const Color(0xFF191C1D),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // ================= SEARCH =================
                      Container(
                        height: 52.h,

                        padding: EdgeInsets.symmetric(horizontal: 16.w),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(12.r),

                          border: Border.all(color: const Color(0xFFE1E3E3)),

                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                              color: Colors.black.withValues(alpha: 0.05),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Color(0xFFBECAB9)),

                            SizedBox(width: 12.w),

                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Cari Pasien...",

                                  hintStyle: TextStyle(
                                    color: const Color(0xFF6B7280),

                                    fontSize: 16.sp,
                                  ),

                                  border: InputBorder.none,
                                  suffixIcon:
                                      _searchQuery.trim().isEmpty
                                          ? null
                                          : IconButton(
                                            onPressed: () {
                                              _searchController.clear();
                                              setState(() {
                                                _searchQuery = '';
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // ================= FILTER =================
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _filterChip("All Patients", _PatientFilter.all),

                            SizedBox(width: 8.w),

                            _filterChip("High Risk", _PatientFilter.highRisk),

                            SizedBox(width: 8.w),

                            _filterChip(
                              "Update Terbaru",
                              _PatientFilter.recentUpdate,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      FutureBuilder<List<PatientSummary>>(
                        future: _patientsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return _messageState(
                              title: 'Gagal memuat pasien',
                              subtitle:
                                  'Tarik layar ke bawah untuk mencoba lagi.',
                            );
                          }

                          final patients = snapshot.data ?? [];
                          final visiblePatients = _visiblePatients(patients);

                          if (patients.isEmpty) {
                            return _messageState(
                              title: 'Belum ada pasien',
                              subtitle:
                                  'Tekan tombol + untuk menambahkan pasien pertama.',
                            );
                          }

                          if (visiblePatients.isEmpty) {
                            return _messageState(
                              title: 'Pasien tidak ditemukan',
                              subtitle:
                                  'Coba ubah kata pencarian atau pilih filter lain.',
                            );
                          }

                          return Column(
                            children: [
                              for (final patient in visiblePatients) ...[
                                _patientCard(
                                  patientId: patient.id,
                                  name: patient.fullName,
                                  id: patient.patientCode,
                                  risk: _riskLabel(
                                    _normalizeRiskLevel(patient.riskLevel),
                                  ),
                                  riskColor: _riskColor(
                                    _normalizeRiskLevel(patient.riskLevel),
                                  ),
                                  riskBg: _riskBg(
                                    _normalizeRiskLevel(patient.riskLevel),
                                  ),
                                  progress: patient.treatmentProgress,
                                  day:
                                      "${(patient.treatmentProgress * 90).round()} of 90 days",
                                  updated: _updatedLabel(patient.lastUpdatedAt),
                                ),
                                SizedBox(height: 16.h),
                              ],
                              SizedBox(height: 84.h),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FILTER CHIP =================
  Widget _filterChip(String label, _PatientFilter filter) {
    final bool active = _selectedFilter == filter;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF4CAF50) : Colors.white,
          borderRadius: BorderRadius.circular(999.r),
          border: active ? null : Border.all(color: const Color(0xFFBECAB9)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: active ? const Color(0xFF003C0B) : const Color(0xFF3F4A3C),
          ),
        ),
      ),
    );
  }

  List<PatientSummary> _visiblePatients(List<PatientSummary> patients) {
    final query = _searchQuery.trim().toLowerCase();
    final filtered =
        patients.where((patient) {
          final riskLevel = _normalizeRiskLevel(patient.riskLevel);
          final matchesFilter =
              _selectedFilter != _PatientFilter.highRisk || riskLevel == 'high';
          final matchesSearch =
              query.isEmpty ||
              patient.fullName.toLowerCase().contains(query) ||
              patient.patientCode.toLowerCase().contains(query) ||
              _riskLabel(riskLevel).toLowerCase().contains(query);

          return matchesFilter && matchesSearch;
        }).toList();

    if (_selectedFilter == _PatientFilter.recentUpdate) {
      filtered.sort((a, b) {
        final dateA = a.lastUpdatedAt ?? a.createdAt;
        final dateB = b.lastUpdatedAt ?? b.createdAt;
        return dateB.compareTo(dateA);
      });
    }

    return filtered;
  }

  String _normalizeRiskLevel(String riskLevel) {
    return riskLevel.trim().toLowerCase();
  }

  Widget _messageState({required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE1E3E3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF191C1D),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF3F4A3C)),
          ),
        ],
      ),
    );
  }

  String _riskLabel(String riskLevel) {
    return switch (riskLevel) {
      'high' => 'High Risk',
      'low' => 'Low Risk',
      _ => 'Medium Risk',
    };
  }

  Color _riskColor(String riskLevel) {
    return switch (riskLevel) {
      'high' => const Color(0xFFBA1A1A),
      'low' => const Color(0xFF5DAC5B),
      _ => const Color(0xFFEAB308),
    };
  }

  Color _riskBg(String riskLevel) {
    return switch (riskLevel) {
      'high' => const Color(0xFFFFDAD6),
      'low' => const Color(0xFFD9E6DA),
      _ => const Color(0xFFFEF9C3),
    };
  }

  String _updatedLabel(DateTime? updatedAt) {
    if (updatedAt == null) return 'Just now';

    final difference = DateTime.now().difference(updatedAt.toLocal());

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes} min ago';
    if (difference.inDays < 1) return '${difference.inHours} hours ago';
    if (difference.inDays == 1) return 'Yesterday';
    return '${difference.inDays} days ago';
  }

  // ================= PATIENT CARD =================
  Widget _patientCard({
    required String patientId,
    required String name,
    required String id,
    required String risk,
    required Color riskColor,
    required Color riskBg,
    required double progress,
    required String day,
    required String updated,
  }) {
    final displayName = name.trim().isEmpty ? 'Pasien' : name.trim();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _openPatientDetail(patientId);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12.r),

          border: Border.all(color: const Color(0xFFF2F4F4)),

          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: 0.04),
            ),
          ],
        ),

        child: Column(
          children: [
            // ================= TOP =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24.r,

                      backgroundColor: const Color(0xFFECEEEE),

                      child: Text(
                        displayName[0].toUpperCase(),

                        style: TextStyle(
                          fontSize: 20.sp,

                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          displayName,

                          style: TextStyle(
                            fontSize: 22.sp,

                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 2.h),

                        Text(
                          "ID: $id",

                          style: TextStyle(
                            fontSize: 14.sp,

                            color: const Color(0xFF3F4A3C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),

                  decoration: BoxDecoration(
                    color: riskBg,

                    borderRadius: BorderRadius.circular(999.r),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.h,

                        decoration: BoxDecoration(
                          color: riskColor,
                          shape: BoxShape.circle,
                        ),
                      ),

                      SizedBox(width: 6.w),

                      Text(
                        risk,

                        style: TextStyle(
                          fontSize: 12.sp,

                          fontWeight: FontWeight.w700,

                          color: riskColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 18.h),

            // ================= PROGRESS =================
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      "Progres Pengobatan",

                      style: TextStyle(
                        fontSize: 14.sp,

                        color: const Color(0xFF3F4A3C),
                      ),
                    ),

                    Text(
                      day,

                      style: TextStyle(
                        fontSize: 12.sp,

                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                ClipRRect(
                  borderRadius: BorderRadius.circular(999.r),

                  child: LinearProgressIndicator(
                    value: progress,

                    minHeight: 6.h,

                    backgroundColor: const Color(0xFFD9E6DA),

                    valueColor: const AlwaysStoppedAnimation(Color(0xFF006E1C)),
                  ),
                ),
              ],
            ),

            SizedBox(height: 18.h),

            // ================= BOTTOM =================
            Container(
              padding: EdgeInsets.only(top: 16.h),

              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE1E3E3))),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,

                        size: 14,

                        color: Color(0xFF3F4A3C),
                      ),

                      SizedBox(width: 6.w),

                      Text(
                        "Last updated: $updated",

                        style: TextStyle(
                          fontSize: 14.sp,

                          color: const Color(0xFF3F4A3C),
                        ),
                      ),
                    ],
                  ),

                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _openPatientDetail(patientId);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFECEEEE),

                        borderRadius: BorderRadius.circular(8.r),
                      ),

                      child: Row(
                        children: [
                          const Icon(
                            Icons.visibility_outlined,
                            size: 12,
                            color: Color(0xFF006E1C),
                          ),

                          SizedBox(width: 6.w),

                          Text(
                            "Detail",

                            style: TextStyle(
                              fontSize: 12.sp,

                              fontWeight: FontWeight.w700,

                              color: const Color(0xFF006E1C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPatientDetail(String patientId) {
    context.push('/patient-detail/${Uri.encodeComponent(patientId)}');
  }
}
