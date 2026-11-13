import 'base_url.dart';

class ApiEndpoints {
  static const String states = 'states/';
  static const String users = 'users/';

  static String get statesUrl => '${BaseUrl.baseUrl}$states';
  static String get registerUrl => '${BaseUrl.baseUrl}$users';
}
