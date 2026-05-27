import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<String> currentDisplayName() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return 'User';
    }

    final metadataName = _stringOrNull(user.userMetadata?['full_name']);

    if (metadataName != null) {
      return metadataName;
    }

    final Map<String, dynamic>? row;

    try {
      row =
          await _client
              .from('profiles')
              .select('full_name, username')
              .eq('id', user.id)
              .maybeSingle();
    } on PostgrestException {
      return _emailName(user.email) ?? 'User';
    }

    final profileName = _stringOrNull(row?['full_name']);
    final username = _stringOrNull(row?['username']);

    return profileName ?? username ?? _emailName(user.email) ?? 'User';
  }

  String currentEmail() {
    return _client.auth.currentUser?.email ?? '-';
  }

  Future<void> updateAccount({
    required String fullName,
    required String email,
    String? newPassword,
  }) async {
    final response = await _client.functions.invoke(
      'update-patient-account',
      body: {'full_name': fullName, 'email': email, 'password': newPassword},
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const AuthException('Gagal memperbarui akun.');
    }

    if (data['error'] != null) {
      throw AuthException(data['error'].toString());
    }

    try {
      await _client.auth.refreshSession();
    } catch (_) {
      // The server-side update already succeeded. Some local sessions do not
      // have a refresh token after account edits, so the app should not show
      // this as a failed profile update.
    }
  }

  String? _emailName(String? email) {
    final localPart = email?.split('@').first.trim();

    if (localPart == null || localPart.isEmpty) {
      return null;
    }

    return localPart
        .replaceAll(RegExp(r'[._-]+'), ' ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String? _stringOrNull(dynamic value) {
    if (value == null) return null;

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
