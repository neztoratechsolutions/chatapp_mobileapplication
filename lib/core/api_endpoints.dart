import 'base_url.dart';

class ApiEndpoints {
  static const String states = 'states/';
  static const String users = 'users/';
  static const String login = 'auth/login';
  static const String forgotPassword = 'auth/forgot-password';
  static const String verifyOtp = 'auth/verify-otp';
  static const String resetPassword = 'auth/reset-password';
  static const String logout = 'auth/logout';
  static const String userStatus = 'user-status/';
  static const String creatorKycBank = 'creator-kyc/bank';
  static const String creatorKyc = 'creator-kyc/';
  static const String creatorVerificationSelfie = 'creator-verification/selfie';
  static const String creatorVerificationVoice = 'creator-verification/voice';
  static const String gallery = 'gallery/';
  static const String pricingDetails = 'pricing-details/';

  static String get statesUrl => '${BaseUrl.baseUrl}$states';
  static String get registerUrl => '${BaseUrl.baseUrl}$users';
  static String get loginUrl => '${BaseUrl.baseUrl}$login';
  static String get forgotPasswordUrl => '${BaseUrl.baseUrl}$forgotPassword';
  static String get verifyOtpUrl => '${BaseUrl.baseUrl}$verifyOtp';
  static String get resetPasswordUrl => '${BaseUrl.baseUrl}$resetPassword';
  static String get logoutUrl => '${BaseUrl.baseUrl}$logout';
  static String get userStatusUrl => '${BaseUrl.baseUrl}$userStatus';
  static String userProfileUrl(dynamic id) => '${BaseUrl.baseUrl}$users$id';
  static String get creatorKycBankUrl => '${BaseUrl.baseUrl}$creatorKycBank';
  static String creatorKycUrl(dynamic userId) => '${BaseUrl.baseUrl}creator-kyc/$userId';
  static String creatorVerificationUrl(dynamic creatorId) => '${BaseUrl.baseUrl}creator-verification/$creatorId';
  static String get creatorVerificationSelfieUrl => '${BaseUrl.baseUrl}$creatorVerificationSelfie';
  static String get creatorVerificationVoiceUrl => '${BaseUrl.baseUrl}$creatorVerificationVoice';
  static String get galleryUrl => '${BaseUrl.baseUrl}$gallery';
  static String userGalleryUrl(dynamic userId) => '${BaseUrl.baseUrl}gallery/user/$userId';
  static String deleteGalleryUrl(dynamic userId, dynamic galleryId) => '${BaseUrl.baseUrl}gallery/user/$userId/$galleryId';
  static String get pricingDetailsUrl => '${BaseUrl.baseUrl}$pricingDetails';
  static String userPricingUrl(dynamic userId) => '${BaseUrl.baseUrl}pricing-details/user/$userId';
  static String pricingIdUrl(dynamic pricingId) => '${BaseUrl.baseUrl}pricing-details/$pricingId';
}
