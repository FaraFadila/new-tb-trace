import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/services/symptom_report_service.dart';

class ReportSymptomPage extends StatefulWidget {
  const ReportSymptomPage({super.key});

  @override
  State<ReportSymptomPage> createState() => _ReportSymptomPageState();
}

class _ReportSymptomPageState extends State<ReportSymptomPage> {
  final SymptomReportService _reportService = SymptomReportService();

  final List<String> symptoms = [
    "Batuk Terus menerus",
    "Nyeri Dada",
    "Penurunan Berat Badan",
    "Demam",
    "Sesak Napas",
    "Kelelahan",
    "Berkeringat dimalam hari",
  ];

  List<String> selectedSymptoms = [];

  bool alreadyTakeMedicine = true;

  double severity = 3;

  DateTime selectedDate = DateTime.now();

  final TextEditingController notesController = TextEditingController();

  bool isSubmitting = false;

  Future<void> _submitReport() async {
    if (isSubmitting) return;

    if (selectedSymptoms.isEmpty) {
      _showMessage("Pilih minimal satu gejala terlebih dahulu.");
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await _reportService.saveReport(
        symptoms: selectedSymptoms,
        alreadyTakeMedicine: alreadyTakeMedicine,
        severity: severity.toInt(),
        startedAt: selectedDate,
        notes: notesController.text,
      );

      if (!mounted) return;

      _showMessage("Laporan gejala berhasil dikirim.");
      Navigator.pop(context);
    } catch (_) {
      _showMessage("Gagal mengirim laporan gejala.");
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
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
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF1),

      body: SafeArea(
        child: Column(
          children: [
            // ================= APPBAR =================
            Container(
              height: 64.h,

              padding: EdgeInsets.symmetric(horizontal: 20.w),

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),

                border: Border(
                  bottom: BorderSide(color: const Color(0xFFE8F8F1)),
                ),

                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    color: Colors.black.withValues(alpha: 0.04),
                  ),
                ],
              ),

              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: Container(
                      width: 36.w,
                      height: 36.h,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),

                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        "Laporkan Gejala",

                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,

                          color: const Color(0xFF047857),
                        ),
                      ),
                    ),
                  ),

                  CircleAvatar(
                    radius: 20.r,

                    backgroundColor: const Color(0xFFE3EAE0),

                    child: Icon(
                      Icons.person,
                      color: const Color(0xFF2EB5FA),
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),

            // ================= BODY =================
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ================= HEADER =================
                    Text(
                      "Apa yang Anda rasakan hari ini?",

                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,

                        color: const Color(0xFF171D17),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      "Silakan catat gejala apa pun yang Anda alami untuk membantu kami memantau perkembangan Anda.",

                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1.5,

                        color: const Color(0xFF3D4A3F),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // ================= SYMPTOMS =================
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          _sectionTitle("Gejala Checklist"),

                          SizedBox(height: 16.h),

                          Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,

                            children:
                                symptoms.map((symptom) {
                                  final isSelected = selectedSymptoms.contains(
                                    symptom,
                                  );

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedSymptoms.remove(symptom);
                                        } else {
                                          selectedSymptoms.add(symptom);
                                        }
                                      });
                                    },

                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.w,
                                        vertical: 10.h,
                                      ),

                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? const Color(0xFF006D37)
                                                : const Color(0xFFF4FBF1),

                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? const Color(0xFF006D37)
                                                  : const Color(0xFFBCCABC),
                                        ),

                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),

                                      child: Text(
                                        symptom,

                                        style: TextStyle(
                                          fontSize: 14.sp,

                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : const Color(0xFF3D4A3F),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ================= MEDICINE =================
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          _sectionTitle("Kepatuhan Minum Obat"),

                          SizedBox(height: 10.h),

                          Text(
                            "Apakah Anda sudah minum obat hari ini?",

                            style: TextStyle(
                              fontSize: 15.sp,

                              color: const Color(0xFF3D4A3F),
                            ),
                          ),

                          SizedBox(height: 18.h),

                          Row(
                            children: [
                              Expanded(
                                child: _medicineButton(
                                  title: "Sudah",

                                  selected: alreadyTakeMedicine,

                                  onTap: () {
                                    setState(() {
                                      alreadyTakeMedicine = true;
                                    });
                                  },
                                ),
                              ),

                              SizedBox(width: 16.w),

                              Expanded(
                                child: _medicineButton(
                                  title: "Belum",

                                  selected: !alreadyTakeMedicine,

                                  onTap: () {
                                    setState(() {
                                      alreadyTakeMedicine = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ================= SEVERITY =================
                    _sectionCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              _sectionTitle("Tingkat Keparahan"),

                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),

                                decoration: BoxDecoration(
                                  color: const Color(0xFF27AE60),

                                  borderRadius: BorderRadius.circular(6.r),
                                ),

                                child: Text(
                                  "Moderate (${severity.toInt()})",

                                  style: TextStyle(
                                    fontSize: 11.sp,

                                    fontWeight: FontWeight.w700,

                                    color: const Color(0xFF00391A),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Slider(
                            value: severity,
                            min: 1,
                            max: 5,
                            divisions: 4,

                            activeColor: const Color(0xFF006D37),

                            onChanged: (value) {
                              setState(() {
                                severity = value;
                              });
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text("(Ringan) 1", style: _smallText()),

                              Text("2", style: _smallText()),

                              Text("3", style: _smallText()),

                              Text("4", style: _smallText()),

                              Text("5 (Parah)", style: _smallText()),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ================= DATE =================
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          _sectionTitle("Kapan gejala ini mulai muncul?"),

                          SizedBox(height: 16.h),

                          GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,

                                initialDate: selectedDate,

                                firstDate: DateTime(2020),

                                lastDate: DateTime.now(),
                              );

                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },

                            child: Container(
                              width: double.infinity,

                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 14.h,
                              ),

                              decoration: BoxDecoration(
                                color: const Color(0xFFF4FBF1),

                                border: Border.all(
                                  color: const Color(0xFFEDF2F7),
                                ),

                                borderRadius: BorderRadius.circular(10.r),
                              ),

                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,

                                    size: 18,

                                    color: Color(0xFF6D7A6E),
                                  ),

                                  SizedBox(width: 12.w),

                                  Text(
                                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",

                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ================= NOTES =================
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          _sectionTitle("Catatan Tambahan"),

                          SizedBox(height: 16.h),

                          TextField(
                            controller: notesController,

                            maxLines: 4,

                            decoration: InputDecoration(
                              hintText:
                                  "Ada detail spesifik tentang gejala Anda?\nContoh: 'Batuk semakin parah di malam hari'",

                              hintStyle: TextStyle(
                                color: const Color(0xFFBCCABC),

                                fontSize: 14.sp,
                              ),

                              filled: true,

                              fillColor: const Color(0xFFF4FBF1),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),

                                borderSide: const BorderSide(
                                  color: Color(0xFFEDF2F7),
                                ),
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),

                                borderSide: const BorderSide(
                                  color: Color(0xFFEDF2F7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // ================= BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,

                      child: ElevatedButton.icon(
                        onPressed: isSubmitting ? null : _submitReport,

                        icon:
                            isSubmitting
                                ? SizedBox(
                                  width: 18.w,
                                  height: 18.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : const Icon(Icons.send, color: Colors.white),

                        label: Text(
                          isSubmitting ? "Mengirim..." : "Kirim Laporan",

                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,

                          elevation: 4,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),

                          backgroundColor: const Color(0xFF006D37),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SECTION CARD =================
  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(20.w),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(color: const Color(0xFFE8F8F1)),

        borderRadius: BorderRadius.circular(12.r),

        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),

      child: child,
    );
  }

  // ================= TITLE =================
  Widget _sectionTitle(String title) {
    return Text(
      title,

      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF171D17),
      ),
    );
  }

  // ================= MEDICINE BUTTON =================
  Widget _medicineButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 58.h,

        decoration: BoxDecoration(
          color: selected ? const Color(0xFF006D37) : const Color(0xFFF4FBF1),

          border: Border.all(color: const Color(0xFFBCCABC)),

          borderRadius: BorderRadius.circular(10.r),
        ),

        child: Center(
          child: Text(
            title,

            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,

              color: selected ? Colors.white : const Color(0xFF3D4A3F),
            ),
          ),
        ),
      ),
    );
  }

  // ================= SMALL TEXT =================
  TextStyle _smallText() {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF3D4A3F),
    );
  }
}
