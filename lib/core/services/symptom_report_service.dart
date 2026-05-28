import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SymptomReportService {
  static const _reportsKey = 'symptom_reports';
  static final ValueNotifier<int> _reportVersion = ValueNotifier<int>(0);

  ValueListenable<int> get reportChanges => _reportVersion;

  Future<void> saveReport({
    required List<String> symptoms,
    required bool alreadyTakeMedicine,
    required int severity,
    required DateTime startedAt,
    required String notes,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final reports = await _loadRawReports(preferences);

    reports.add({
      'symptoms': symptoms,
      'already_take_medicine': alreadyTakeMedicine,
      'severity': severity,
      'started_at': startedAt.toIso8601String(),
      'reported_at': DateTime.now().toIso8601String(),
      'notes': notes.trim(),
    });

    await preferences.setString(_reportsKey, jsonEncode(reports));
    _reportVersion.value++;
  }

  Future<List<SymptomTrend>> recentTrends() async {
    final preferences = await SharedPreferences.getInstance();
    final reports = await _loadRawReports(preferences);
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    final recentReports =
        reports.where((report) {
          final reportedAt = DateTime.tryParse(
            report['reported_at']?.toString() ?? '',
          );
          return reportedAt != null && !reportedAt.isBefore(cutoff);
        }).toList();

    if (recentReports.isEmpty) {
      return const [
        SymptomTrend(label: 'Batuk Terus Menerus', value: 0.85),
        SymptomTrend(label: 'Demam', value: 0.62),
        SymptomTrend(label: 'Berkeringat Malam', value: 0.45),
        SymptomTrend(label: 'Kepatuhan Minum Obat', value: 0.92),
      ];
    }

    final totalReports = recentReports.length;
    final symptomSets =
        recentReports.map((report) {
          final symptoms = report['symptoms'];
          if (symptoms is! List) return <String>{};

          return symptoms.map((symptom) => _normalize(symptom)).toSet();
        }).toList();

    final medicineCount =
        recentReports
            .where((report) => report['already_take_medicine'] == true)
            .length;

    return [
      SymptomTrend(
        label: 'Batuk Terus Menerus',
        value: _ratio(
          symptomSets.where((symptoms) => symptoms.contains('batuk')).length,
          totalReports,
        ),
      ),
      SymptomTrend(
        label: 'Demam',
        value: _ratio(
          symptomSets.where((symptoms) => symptoms.contains('demam')).length,
          totalReports,
        ),
      ),
      SymptomTrend(
        label: 'Berkeringat Malam',
        value: _ratio(
          symptomSets.where((symptoms) => symptoms.contains('keringat')).length,
          totalReports,
        ),
      ),
      SymptomTrend(
        label: 'Kepatuhan Minum Obat',
        value: _ratio(medicineCount, totalReports),
      ),
    ];
  }

  Future<List<Map<String, dynamic>>> _loadRawReports(
    SharedPreferences preferences,
  ) async {
    final rawReports = preferences.getString(_reportsKey);
    if (rawReports == null || rawReports.trim().isEmpty) return [];

    try {
      final decoded = jsonDecode(rawReports);
      if (decoded is! List) return [];

      return decoded
          .whereType<Map>()
          .map((report) => Map<String, dynamic>.from(report))
          .toList();
    } on FormatException {
      await preferences.remove(_reportsKey);
      return [];
    }
  }

  static String _normalize(Object? value) {
    final text = value.toString().toLowerCase();
    if (text.contains('batuk')) return 'batuk';
    if (text.contains('demam')) return 'demam';
    if (text.contains('keringat')) return 'keringat';
    return text;
  }

  static double _ratio(int count, int total) {
    if (total == 0) return 0;
    return count / total;
  }
}

class SymptomTrend {
  const SymptomTrend({required this.label, required this.value});

  final String label;
  final double value;
}
