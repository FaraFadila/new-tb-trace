import 'package:supabase_flutter/supabase_flutter.dart';

enum AppUserRole { patient, healthcare, admin }

class AuthService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<AppUserRole> signIn({
    required String email,
    required String password,
  }) async {
    final signInEmail =
        email.contains('@')
            ? email
            : '${email.toLowerCase()}@patients.tb-trace.local';

    final response = await _client.auth.signInWithPassword(
      email: signInEmail,
      password: password,
    );

    if (response.user == null) {
      throw const AuthException('Login gagal. Coba lagi.');
    }

    return currentUserRole();
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    AppUserRole role = AppUserRole.patient,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'role': role.name},
    );

    if (response.user == null) {
      throw const AuthException('Registrasi gagal. Coba lagi.');
    }

    return response.session != null;
  }

  Future<void> signOut() {
    return _client.auth.signOut();
  }

  Future<AppUserRole> currentUserRole() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User belum login.');
    }

    final Map<String, dynamic>? row;

    try {
      row =
          await _client
              .from('profiles')
              .select('role')
              .eq('id', user.id)
              .maybeSingle();
    } on PostgrestException {
      final metadataRole = user.userMetadata?['role'] as String?;
      return _roleFromString(metadataRole ?? AppUserRole.patient.name);
    }

    final role =
        row?['role'] as String? ??
        user.userMetadata?['role'] as String? ??
        AppUserRole.patient.name;
    return _roleFromString(role);
  }

  static String homeRouteFor(AppUserRole role) {
    return switch (role) {
      AppUserRole.healthcare || AppUserRole.admin => '/home-healthcare',
      AppUserRole.patient => '/home-patient',
    };
  }

  static AppUserRole _roleFromString(String role) {
    return switch (role.trim().toLowerCase()) {
      'healthcare' || 'doctor' || 'dokter' => AppUserRole.healthcare,
      'admin' => AppUserRole.admin,
      _ => AppUserRole.patient,
    };
  }
}
