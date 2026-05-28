import 'package:zikmuzik/core/api/api_endpoint.dart';
import 'package:zikmuzik/core/api/dio_client.dart';
import 'package:zikmuzik/core/storages/secure_storage.dart';
import 'package:zikmuzik/features/auth/data/models/api_response.dart';

class AuthRepository {
  Future<ApiResponse> loginWithEmail(String email, String password) async {
    final response = await DioClient.instance.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    return apiResponse;
  }

  Future<bool> refreshToken() async {
    try {
      final response = await DioClient.instance.post(ApiEndpoints.refresh);
      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
      // final newToken = response.data['accessToken'] ?? response.data['token'];
      final newToken = apiResponse.data['accessToken'];

      if (newToken != null) {
        await SecureStorage.saveAccessToken(newToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<ApiResponse> getMe() async {
    final response = await DioClient.instance.get(ApiEndpoints.me);
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }

  Future<void> logout() async {
    try {
      await DioClient.instance.post(ApiEndpoints.logout);
    } catch (_) {}
    await SecureStorage.deleteAccessToken();
  }

  Future<dynamic> getCurrentUser() async {
    final response = await DioClient.instance.get(ApiEndpoints.me);
    return response.data;
  }

  // Google / Social
  Future<dynamic> loginWithGoogle(String idToken) async {
    final response = await DioClient.instance.post(
      ApiEndpoints.socialVerify,
      data: {'idToken': idToken},
    );

    final loginResponse = response.data;
    print("Google login response: $loginResponse['accessToken']");
    await SecureStorage.saveAccessToken(loginResponse['accessToken']);
    return loginResponse;
  }
}
