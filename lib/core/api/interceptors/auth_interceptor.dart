import 'package:dio/dio.dart';
import 'package:zikmuzik/core/api/api_endpoint.dart';
import 'package:zikmuzik/core/api/dio_client.dart';
import 'package:zikmuzik/core/storages/secure_storage.dart';
import 'package:zikmuzik/features/auth/data/repositories/auth_repository.dart';

class AuthInterceptor extends QueuedInterceptor {
  bool _isRefreshing = false;

  final _skipRefreshPaths = [
    ApiEndpoints.login,
    ApiEndpoints.refresh,
    ApiEndpoints.socialVerify,
    ApiEndpoints.logout,
  ];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final original = err.requestOptions;

    // 1. Pas un 401 → on laisse passer
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // 2. Route à ignorer (login, refresh...) ou déjà réessayée
    final shouldSkip = _skipRefreshPaths.any((p) => original.path.contains(p));
    if (shouldSkip || original.extra['retried'] == true) {
      return handler.next(err);
    }

    // 3. Évite plusieurs refresh en même temps
    if (_isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;
    try {
      final success = await AuthRepository().refreshToken();

      if (success) {
        final newToken = await SecureStorage.getAccessToken();
        original.headers['Authorization'] = 'Bearer $newToken';
        original.extra['retried'] = true;

        // rejoue la requête originale
        final response = await DioClient.instance.fetch(original);
        return handler.resolve(response);
      } else {
        await AuthRepository().logout();
      }
    } catch (_) {
      await AuthRepository().logout();
    } finally {
      _isRefreshing = false;
    }

    return handler.next(err);
  }
}
