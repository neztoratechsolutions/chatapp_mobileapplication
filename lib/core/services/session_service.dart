import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyRole = 'user_role';
  static const String keyEmail = 'user_email';
  static const String keyDisplayName = 'display_name';

  // In-memory cache for synchronous access throughout app runtime
  static int cachedUserId = 21;
  static String cachedRole = '';
  static String cachedToken = '';
  static String cachedEmail = '';
  static bool cachedIsLoggedIn = false;

  /// Initialize and load saved session on app startup
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      cachedIsLoggedIn = prefs.getBool(keyIsLoggedIn) ?? false;
      cachedUserId = prefs.getInt(keyUserId) ?? 21;
      cachedRole = prefs.getString(keyRole) ?? '';
      cachedToken = prefs.getString(keyToken) ?? '';
      cachedEmail = prefs.getString(keyEmail) ?? '';

      print('========================================');
      print('SessionService initialized:');
      print('isLoggedIn: $cachedIsLoggedIn');
      print('userId: $cachedUserId');
      print('role: $cachedRole');
      print('========================================');
    } catch (e) {
      print('SessionService init warning: $e');
    }
  }

  /// Save login details to SharedPreferences
  static Future<void> saveLoginSession({
    required int userId,
    required String role,
    String token = '',
    String email = '',
    String displayName = '',
  }) async {
    cachedUserId = userId > 0 ? userId : 21;
    cachedRole = role.toLowerCase().trim();
    if (token.isNotEmpty) {
      cachedToken = token;
    }
    if (email.isNotEmpty) {
      cachedEmail = email;
    }
    cachedIsLoggedIn = true;

    print('========================================');
    print('Saving Login Session: userId=$cachedUserId, role=$cachedRole');
    print('========================================');

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyIsLoggedIn, true);
      await prefs.setInt(keyUserId, cachedUserId);
      await prefs.setString(keyRole, cachedRole);
      if (token.isNotEmpty) {
        await prefs.setString(keyToken, token);
      }
      if (email.isNotEmpty) {
        await prefs.setString(keyEmail, email);
      }
      if (displayName.isNotEmpty) {
        await prefs.setString(keyDisplayName, displayName);
      }
    } catch (e) {
      print('Error saving session to SharedPreferences: $e');
    }
  }

  /// Get currently logged in User ID (defaults to 21 if not found)
  static Future<int> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt(keyUserId) ?? cachedUserId;
      return id > 0 ? id : 21;
    } catch (_) {
      return cachedUserId > 0 ? cachedUserId : 21;
    }
  }

  /// Get saved role
  static Future<String> getRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(keyRole) ?? cachedRole;
    } catch (_) {
      return cachedRole;
    }
  }

  /// Get saved auth token
  static Future<String> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(keyToken) ?? cachedToken;
    } catch (_) {
      return cachedToken;
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(keyIsLoggedIn) ?? cachedIsLoggedIn;
    } catch (_) {
      return cachedIsLoggedIn;
    }
  }

  /// Clear all saved session data on Logout
  static Future<void> clearSession() async {
    print('========================================');
    print('Clearing Login Session from SharedPreferences...');
    print('========================================');

    cachedIsLoggedIn = false;
    cachedUserId = 21;
    cachedRole = '';
    cachedToken = '';
    cachedEmail = '';

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing SharedPreferences: $e');
    }
  }
}
