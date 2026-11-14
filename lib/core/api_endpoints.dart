import 'base_url.dart';

class ApiEndpoints {
  static const String states = 'states/';
  static const String users = 'users/';
  static const String login = 'auth/login';
  static const String forgotPassword = 'auth/forgot-password';
  static const String verifyOtp = 'auth/verify-otp';
  static const String resetPassword = 'auth/reset-password';
  static const String logout = 'auth/logout';

  static String get statesUrl => '${BaseUrl.baseUrl}$states';
  static String get registerUrl => '${BaseUrl.baseUrl}$users';
  static String get loginUrl => '${BaseUrl.baseUrl}$login';
  static String get forgotPasswordUrl => '${BaseUrl.baseUrl}$forgotPassword';
  static String get verifyOtpUrl => '${BaseUrl.baseUrl}$verifyOtp';
  static String get resetPasswordUrl => '${BaseUrl.baseUrl}$resetPassword';
  static String get logoutUrl => '${BaseUrl.baseUrl}$logout';
}
