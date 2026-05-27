import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileService {
  static const _cachedUserIdKey = 'current_user_id';
  static const _cachedDisplayNameKey = 'current_user_display_name';
  static const _cachedEmailKey = 'current_user_email';

  SupabaseClient get _client => Supabase.instance.client;

  Future<String> currentDisplayName() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return await _cachedDisplayName(userId: null) ?? 'User';
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
      return await _cachedDisplayName(userId: user.id) ??
          _emailName(user.email) ??
          'User';
    }

    final profileName = _stringOrNull(row?['full_name']);
    final username = _stringOrNull(row?['username']);
    final metadataName = _stringOrNull(user.userMetadata?['full_name']);

    final displayName =
        profileName ??
        username ??
        metadataName ??
        _emailName(user.email) ??
        'User';

    await _cacheProfile(
      userId: user.id,
      displayName: displayName,
      email: user.email,
    );
    return displayName;
  }

  String currentEmail() {
    return _client.auth.currentUser?.email ?? '-';
  }

  Future<String> currentEmailDisplay() async {
    final user = _client.auth.currentUser;
    return _stringOrNull(user?.email) ??
        await _cachedEmail(userId: user?.id) ??
        '-';
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

    final updatedFullName = _stringOrNull(data['full_name']) ?? fullName;
    final updatedEmail = _stringOrNull(data['email']) ?? email;
    final updatedPassword = _stringOrNull(newPassword);
    await _cacheProfile(
      userId: _client.auth.currentUser?.id,
      displayName: updatedFullName,
      email: updatedEmail,
    );

    try {
      if (updatedPassword != null) {
        await _client.auth.signInWithPassword(
          email: updatedEmail,
          password: updatedPassword,
        );
      } else {
        await _client.auth.refreshSession();
      }
    } catch (_) {
      // The server-side update already succeeded. Some local sessions do not
      // have a refresh token after account edits, so the app should not show
      // this as a failed profile update.
    }

    await _cacheProfile(
      userId: _client.auth.currentUser?.id,
      displayName: updatedFullName,
      email: _client.auth.currentUser?.email ?? updatedEmail,
    );
  }

  Future<void> _cacheProfile({
    required String? userId,
    required String displayName,
    required String? email,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final cleanUserId = _stringOrNull(userId);
    if (cleanUserId != null) {
      await preferences.setString(_cachedUserIdKey, cleanUserId);
    }

    await preferences.setString(_cachedDisplayNameKey, displayName);

    final cleanEmail = _stringOrNull(email);
    if (cleanEmail != null) {
      await preferences.setString(_cachedEmailKey, cleanEmail);
    }
  }

  Future<void> clearCachedProfile() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_cachedUserIdKey);
    await preferences.remove(_cachedDisplayNameKey);
    await preferences.remove(_cachedEmailKey);
  }

  Future<String?> _cachedDisplayName({required String? userId}) async {
    final preferences = await SharedPreferences.getInstance();
    if (!_matchesCachedUser(preferences, userId)) return null;

    return _stringOrNull(preferences.getString(_cachedDisplayNameKey));
  }

  Future<String?> _cachedEmail({required String? userId}) async {
    final preferences = await SharedPreferences.getInstance();
    if (!_matchesCachedUser(preferences, userId)) return null;

    return _stringOrNull(preferences.getString(_cachedEmailKey));
  }

  bool _matchesCachedUser(SharedPreferences preferences, String? userId) {
    final expectedUserId = _stringOrNull(userId);
    if (expectedUserId == null) return true;

    return _stringOrNull(preferences.getString(_cachedUserIdKey)) ==
        expectedUserId;
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
