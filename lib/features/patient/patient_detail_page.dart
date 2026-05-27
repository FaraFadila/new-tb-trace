import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tb_trace/core/services/patient_service.dart';
import 'package:tb_trace/core/widgets/app_user_header.dart';
import 'package:tb_trace/core/widgets/healthcare_bottom_navbar.dart';

class PatientDetailPage extends StatefulWidget {
  const PatientDetailPage({super.key, required this.patientId});

  final String patientId;

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  final PatientService _patientService = PatientService();
  late Future<PatientDetail> _patientFuture;

  @override
  void initState() {
    super.initState();
    _patientFuture = _patientService.getPatientDetail(widget.patientId);
  }

  Future<void> _refreshPatient() async {
    setState(() {
      _patientFuture = _patientService.getPatientDetail(widget.patientId);
    });

    await _patientFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      appBar: const AppPageHeader(
        title: 'Detail Pasien',
        fallbackRoute: '/patient-management',
      ),
      bottomNavigationBar: const HealthcareBottomNavbar(currentIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshPatient,
                child: FutureBuilder<PatientDetail>(
                  future: _patientFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(20.w),
                        children: [
                          _messageState(
                            title: 'Gagal memuat detail pasien',
                            subtitle:
                                'Tarik layar ke bawah untuk mencoba lagi.',
                          ),
                        ],
                      );
                    }

                    final patient = snapshot.data;

                    if (patient == null) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(20.w),
                        children: [
                          _messageState(
                            title: 'Pasien tidak ditemukan',
                            subtitle: 'Data pasien ini tidak tersedia.',
                          ),
                        ],
                      );
                    }

                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(20.w),
                      children: [
                        _summaryCard(patient),
                        SizedBox(height: 16.h),
                        _updateProgressButton(patient.id),
                        SizedBox(height: 16.h),
                        _detailSection(
                          title: 'Informasi Pasien',
                          children: [
                            _detailRow('Nama Lengkap', patient.fullName),
                            _detailRow('ID Pasien', patient.patientCode),
                            _detailRow('Nomor Telepon', patient.phone),
                            _detailRow('Alamat', patient.address),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _detailSection(
                          title: 'Akun Login Pasien',
                          children: [
                            _credentialRow(
                              label: 'Email',
                              value: patient.loginEmail,
                            ),
                            _credentialRow(
                              label: 'Password',
                              value: patient.temporaryPassword,
                              emptyLabel: 'Belum tersimpan',
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Password hanya bisa ditampilkan kalau temporary password pasien disimpan saat akun dibuat.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                height: 1.4,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _detailSection(
                          title: 'Kontak Wali',
                          children: [
                            _detailRow('Nama Wali', patient.guardianName),
                            _detailRow('Nomor Wali', patient.guardianPhone),
                            _detailRow('Alamat Wali', patient.guardianAddress),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _detailSection(
                          title: 'Pengobatan',
                          children: [
                            _detailRow(
                              'Status',
                              _treatmentStatusLabel(patient.treatmentStatus),
                            ),
                            _detailRow(
                              'Mulai Pengobatan',
                              _dateLabel(patient.treatmentStartDate),
                            ),
                            _detailRow(
                              'Selesai Pengobatan',
                              _dateLabel(patient.treatmentEndDate),
                            ),
                            _detailRow(
                              'Update Terakhir',
                              _dateTimeLabel(patient.lastUpdatedAt),
                            ),
                          ],
                        ),
                        SizedBox(height: 84.h),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _updateProgressButton(String patientId) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton.icon(
        onPressed: () async {
          final updated = await context.push<bool>(
            '/patient-progress/${Uri.encodeComponent(patientId)}',
          );

          if (!mounted || updated != true) return;

          _refreshPatient();
        },
        icon: Icon(Icons.trending_up_rounded, size: 20.sp),
        label: Text(
          'Update Progress Pengobatan',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF006D37),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(PatientDetail patient) {
    final riskLevel = patient.riskLevel;
    final progressPercent = (patient.treatmentProgress * 100).round();

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE1E3E3)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: const Color(0xFFECEEEE),
                child: Text(
                  patient.fullName.isEmpty
                      ? '?'
                      : patient.fullName[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF191C1D),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.fullName,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF191C1D),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      patient.patientCode,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF3F4A3C),
                      ),
                    ),
                  ],
                ),
              ),
              _statusChip(
                label: _riskLabel(riskLevel),
                textColor: _riskColor(riskLevel),
                backgroundColor: _riskBg(riskLevel),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progres Pengobatan',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF3F4A3C),
                ),
              ),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF006E1C),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: patient.treatmentProgress,
              minHeight: 8.h,
              backgroundColor: const Color(0xFFD9E6DA),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF006E1C)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE1E3E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF191C1D),
            ),
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String? value) {
    final displayValue =
        value == null || value.trim().isEmpty ? '-' : value.trim();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF191C1D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _credentialRow({
    required String label,
    required String? value,
    String emptyLabel = '-',
  }) {
    final displayValue =
        value == null || value.trim().isEmpty ? emptyLabel : value.trim();
    final canCopy = value != null && value.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 132.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color:
                    canCopy ? const Color(0xFF191C1D) : const Color(0xFF6B7280),
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed:
                canCopy
                    ? () {
                      Clipboard.setData(ClipboardData(text: displayValue));
                      _showCopiedMessage('$label berhasil disalin.');
                    }
                    : null,
            icon: Icon(
              Icons.copy_rounded,
              size: 18.sp,
              color:
                  canCopy ? const Color(0xFF006E1C) : const Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }

  void _showCopiedMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _statusChip({
    required String label,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
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
            textAlign: TextAlign.center,
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

  String _treatmentStatusLabel(String status) {
    return switch (status) {
      'completed' => 'Selesai',
      'paused' => 'Dijeda',
      'inactive' => 'Tidak Aktif',
      _ => 'Aktif',
    };
  }

  String _dateLabel(DateTime? date) {
    if (date == null) return '-';
    final localDate = date.toLocal();
    return '${localDate.day.toString().padLeft(2, '0')}/${localDate.month.toString().padLeft(2, '0')}/${localDate.year}';
  }

  String _dateTimeLabel(DateTime? date) {
    if (date == null) return '-';
    final localDate = date.toLocal();
    final dateLabel = _dateLabel(localDate);
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');
    return '$dateLabel $hour:$minute';
  }
}
