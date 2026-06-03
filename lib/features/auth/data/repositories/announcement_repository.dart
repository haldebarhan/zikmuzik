import 'package:zikmuzik/core/api/api_endpoint.dart';
import 'package:zikmuzik/core/api/dio_client.dart';
import 'package:zikmuzik/features/auth/data/models/api_response.dart';

class AnnouncementRepository {
  Future<ApiResponse> getAnnouncements({int page = 1, int limit = 10}) async {
    final request = await DioClient.instance.get(
      ApiEndpoints.announcements,
      // queryParameters: {'page': page, 'limit': limit},
    );
    final apiResponse = ApiResponse.fromJson(
      request.data,
      (json) => json as Map<String, dynamic>,
    );
    return apiResponse;
  }
}
