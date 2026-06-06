import 'package:supabase_flutter/supabase_flutter.dart';

class CreatedPatientCredentials {
  const CreatedPatientCredentials({
    required this.username,
    required this.email,
    required this.temporaryPassword,
  });

  final String username;
  final String email;
  final String temporaryPassword;
}

class PatientSummary {
  const PatientSummary({
    required this.id,
    required this.patientCode,
    required this.fullName,
    required this.riskLevel,
    required this.treatmentProgress,
    required this.createdAt,
    this.lastUpdatedAt,
  });

  final String id;
  final String patientCode;
  final String fullName;
  final String riskLevel;
  final double treatmentProgress;
  final DateTime createdAt;
  final DateTime? lastUpdatedAt;

  factory PatientSummary.fromJson(Map<String, dynamic> json) {
    return PatientSummary(
      id: json['id'] as String,
      patientCode: json['patient_code'] as String,
      fullName: json['full_name'] as String,
      riskLevel:
          (json['risk_level'] as String? ?? 'medium').trim().toLowerCase(),
      treatmentProgress:
          double.tryParse(json['treatment_progress'].toString()) ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastUpdatedAt:
          json['last_updated_at'] == null
              ? null
              : DateTime.parse(json['last_updated_at'] as String),
    );
  }
}

class PatientDetail {
  const PatientDetail({
    required this.id,
    required this.patientCode,
    required this.fullName,
    required this.riskLevel,
    required this.treatmentStatus,
    required this.treatmentProgress,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.address,
    this.guardianName,
    this.guardianPhone,
    this.guardianAddress,
    this.loginEmail,
    this.temporaryPassword,
    this.treatmentStartDate,
    this.treatmentEndDate,
    this.lastUpdatedAt,
  });

  final String id;
  final String patientCode;
  final String fullName;
  final String? phone;
  final String? address;
  final String? guardianName;
  final String? guardianPhone;
  final String? guardianAddress;
  final String? loginEmail;
  final String? temporaryPassword;
  final String riskLevel;
  final String treatmentStatus;
  final DateTime? treatmentStartDate;
  final DateTime? treatmentEndDate;
  final double treatmentProgress;
  final DateTime? lastUpdatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory PatientDetail.fromJson(Map<String, dynamic> json) {
    final patientCode = json['patient_code'] as String;

    return PatientDetail(
      id: json['id'] as String,
      patientCode: patientCode,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      guardianName: json['guardian_name'] as String?,
      guardianPhone: json['guardian_phone'] as String?,
      guardianAddress: json['guardian_address'] as String?,
      loginEmail:
          _stringOrNull(json['login_email']) ??
          _stringOrNull(json['patient_email']) ??
          _stringOrNull(json['email']) ??
          '${patientCode.toLowerCase()}@patients.tb-trace.local',
      temporaryPassword:
          _stringOrNull(json['temporary_password']) ??
          _stringOrNull(json['patient_password']) ??
          _stringOrNull(json['plain_password']),
      riskLevel:
          (json['risk_level'] as String? ?? 'medium').trim().toLowerCase(),
      treatmentStatus:
          (json['treatment_status'] as String? ?? 'active')
              .trim()
              .toLowerCase(),
      treatmentStartDate: _parseOptionalDate(json['treatment_start_date']),
      treatmentEndDate: _parseOptionalDate(json['treatment_end_date']),
      treatmentProgress:
          double.tryParse(json['treatment_progress'].toString()) ?? 0,
      lastUpdatedAt: _parseOptionalDate(json['last_updated_at']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static DateTime? _parseOptionalDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static String? _stringOrNull(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}

class PatientService {
  SupabaseClient get _client => Supabase.instance.client;

  static String riskLevelForTreatmentProgress(double progress) {
    final treatmentMonth = treatmentMonthForProgress(progress);

    if (treatmentMonth <= 1) return 'high';
    if (treatmentMonth <= 3) return 'medium';
    return 'low';
  }

  static int treatmentMonthForProgress(double progress) {
    final clampedProgress = progress.clamp(0.0, 1.0).toDouble();
    if (clampedProgress == 0) return 1;

    return (clampedProgress * 6).round().clamp(1, 6);
  }

  Future<List<PatientSummary>> listPatients() async {
    final rows = await _client
        .from('patients')
        .select(
          'id, patient_code, full_name, risk_level, treatment_progress, created_at, last_updated_at',
        )
        .order('created_at', ascending: false);

    return rows.map((row) => PatientSummary.fromJson(row)).toList();
  }

  Future<PatientDetail> getPatientDetail(String patientId) async {
    final row =
        await _client
            .from('patients')
            .select(
              'id, patient_code, full_name, phone, address, guardian_name, guardian_phone, guardian_address, login_email, temporary_password, risk_level, treatment_status, treatment_start_date, treatment_end_date, treatment_progress, last_updated_at, created_at, updated_at',
            )
            .eq('id', patientId)
            .maybeSingle();

    if (row == null) {
      throw const AuthException('Pasien tidak ditemukan.');
    }

    return PatientDetail.fromJson(row);
  }

  Future<PatientDetail> getCurrentPatientDetail() async {
    final userId = _client.auth.currentUser?.id;

    if (userId == null) {
      throw const AuthException('User belum login.');
    }

    final row =
        await _client
            .from('patients')
            .select(
              'id, patient_code, full_name, phone, address, guardian_name, guardian_phone, guardian_address, login_email, temporary_password, risk_level, treatment_status, treatment_start_date, treatment_end_date, treatment_progress, last_updated_at, created_at, updated_at',
            )
            .eq('user_id', userId)
            .maybeSingle();

    if (row == null) {
      throw const AuthException('Data pasien tidak ditemukan.');
    }

    return PatientDetail.fromJson(row);
  }

  Future<CreatedPatientCredentials> createPatient({
    required String fullName,
    String? phone,
    String? address,
    String? guardianName,
    String? guardianPhone,
    String? guardianAddress,
    String? kelurahan,
    double? latitude,
    double? longitude,
    String? treatmentStartDate,
    String? treatmentEndDate,
  }) async {
    final response = await _client.functions.invoke(
      'create-patient',
      body: {
        'full_name': fullName,
        'phone': phone,
        'address': address,
        'guardian_name': guardianName,
        'guardian_phone': guardianPhone,
        'guardian_address': guardianAddress,
        'kelurahan': kelurahan,
        'latitude': latitude,
        'longitude': longitude,
        'treatment_start_date': treatmentStartDate,
        'treatment_end_date': treatmentEndDate,
      },
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const AuthException('Gagal membuat pasien.');
    }

    if (data['error'] != null) {
      throw AuthException(data['error'].toString());
    }

    final credentials = data['credentials'] as Map<String, dynamic>?;

    if (credentials == null) {
      throw const AuthException('Credential pasien tidak ditemukan.');
    }

    final createdCredentials = CreatedPatientCredentials(
      username: credentials['username'] as String,
      email: credentials['email'] as String,
      temporaryPassword: credentials['temporary_password'] as String,
    );

    return createdCredentials;
  }

  Future<PatientDetail> updateTreatmentProgress({
    required String patientId,
    required double treatmentProgress,
  }) async {
    final clampedProgress = treatmentProgress.clamp(0.0, 1.0).toDouble();
    final riskLevel = riskLevelForTreatmentProgress(clampedProgress);
    final now = DateTime.now().toUtc().toIso8601String();
    final row =
        await _client
            .from('patients')
            .update({
              'treatment_progress': clampedProgress,
              'risk_level': riskLevel,
              'treatment_status': clampedProgress >= 1 ? 'completed' : 'active',
              'last_updated_at': now,
              'updated_at': now,
            })
            .eq('id', patientId)
            .select(
              'id, patient_code, full_name, phone, address, guardian_name, guardian_phone, guardian_address, login_email, temporary_password, risk_level, treatment_status, treatment_start_date, treatment_end_date, treatment_progress, last_updated_at, created_at, updated_at',
            )
            .maybeSingle();

    if (row == null) {
      throw const AuthException('Pasien tidak ditemukan.');
    }

    return PatientDetail.fromJson(row);
  }
}
