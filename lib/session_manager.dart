// ============================================================
// session_manager.dart – User Session via SharedPreferences
// Persists logged-in userId across app restarts
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyUserId   = 'session_userId';
  static const _keyUsername = 'session_username';

  // ── Save session after login ──────────────────────────────
  static Future<void> saveSession({
    required int    userId,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(   _keyUserId,   userId);
    await prefs.setString(_keyUsername, username);
  }

  // ── Get stored userId (null = not logged in) ─────────────
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  // ── Get stored username ──────────────────────────────────
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // ── Check if a session exists ────────────────────────────
  static Future<bool> isLoggedIn() async {
    final id = await getUserId();
    return id != null;
  }

  // ── Clear session on logout ──────────────────────────────
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUsername);
  }
}
