import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tb_trace/core/services/patient_service.dart';
import 'package:tb_trace/core/widgets/app_user_header.dart';
import 'package:tb_trace/core/widgets/healthcare_bottom_navbar.dart';

class PatientProgressPage extends StatefulWidget {
  const PatientProgressPage({super.key, required this.patientId});

  final String patientId;

  @override
  State<PatientProgressPage> createState() => _PatientProgressPageState();
}

class _PatientProgressPageState extends State<PatientProgressPage> {
  final PatientService _patientService = PatientService();
  late Future<PatientDetail> _patientFuture;
  double _progress = 0;
  bool _hasLoadedInitialProgress = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _patientFuture = _patientService.getPatientDetail(widget.patientId);
  }

  Future<void> _saveProgress() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _patientService.updateTreatmentProgress(
        patientId: widget.patientId,
        treatmentProgress: _progress,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress pasien berhasil diperbarui.')),
      );
      context.pop(true);
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('Gagal memperbarui progress pasien.');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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
      backgroundColor: const Color(0xFFF8FAFA),
      appBar: const AppPageHeader(
        title: 'Update Progress',
        fallbackRoute: '/patient-management',
      ),
      bottomNavigationBar: const HealthcareBottomNavbar(currentIndex: 3),
      body: SafeArea(
        child: FutureBuilder<PatientDetail>(
          future: _patientFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || snapshot.data == null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20.w),
                children: [
                  _messageState(
                    title: 'Gagal memuat pasien',
                    subtitle: 'Kembali lalu coba buka halaman ini lagi.',
                  ),
                ],
              );
            }

            final patient = snapshot.data!;

            if (!_hasLoadedInitialProgress) {
              _progress = patient.treatmentProgress.clamp(0.0, 1.0).toDouble();
              _hasLoadedInitialProgress = true;
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(20.w),
              children: [
                _progressCard(patient),
                SizedBox(height: 20.h),
                _saveButton(),
                SizedBox(height: 84.h),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _progressCard(PatientDetail patient) {
    final riskLevel = PatientService.riskLevelForTreatmentProgress(_progress);
    final treatmentMonth = PatientService.treatmentMonthForProgress(_progress);
    final progressPercent = (_progress * 100).round();

    return Container(
      width: double.infinity,
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
          _patientChip(patient),
          SizedBox(height: 28.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progres Pengobatan',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3F4A3C),
                ),
              ),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF006E1C),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF006E1C),
              inactiveTrackColor: const Color(0xFFE1E3E3),
              thumbColor: const Color(0xFF006E1C),
              overlayColor: const Color(0x33006E1C),
              trackHeight: 8.h,
            ),
            child: Slider(
              value: _progress,
              min: 0,
              max: 1,
              divisions: 6,
              onChanged:
                  _isSaving
                      ? null
                      : (value) {
                        setState(() {
                          _progress = value;
                        });
                      },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0%',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
              Text(
                'Bulan $treatmentMonth dari 6',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF191C1D),
                ),
              ),
              Text(
                '100%',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          SizedBox(height: 28.h),
          Text(
            'Risk Level',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3F4A3C),
            ),
          ),
          SizedBox(height: 12.h),
          _riskSelector(riskLevel),
        ],
      ),
    );
  }

  Widget _patientChip(PatientDetail patient) {
    final displayName =
        patient.fullName.trim().isEmpty ? 'Pasien' : patient.fullName.trim();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFD9E6DA).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFD9E6DA)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: const Color(0xFFBA1A1A),
            child: Text(
              displayName[0].toUpperCase(),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3F4A3C),
                ),
              ),
              Text(
                patient.patientCode,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _riskSelector(String riskLevel) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFECEEEE),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _riskItem(title: 'Low', value: 'low', selectedValue: riskLevel),
          _riskItem(title: 'Medium', value: 'medium', selectedValue: riskLevel),
          _riskItem(title: 'High', value: 'high', selectedValue: riskLevel),
        ],
      ),
    );
  }

  Widget _riskItem({
    required String title,
    required String value,
    required String selectedValue,
  }) {
    final isSelected = value == selectedValue;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(vertical: 11.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border:
              isSelected
                  ? Border.all(
                    color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                  )
                  : null,
          boxShadow:
              isSelected
                  ? const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 2,
                    ),
                  ]
                  : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color:
                isSelected ? const Color(0xFF191C1D) : const Color(0xFF6F7A6B),
          ),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveProgress,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF006D37),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF8BB99D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child:
            _isSaving
                ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
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
}
