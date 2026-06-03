class PaginatedResponse<T> {
  final int statusCode;
  final String timestamp;
  final ResponseItems<T> items;

  PaginatedResponse({
    required this.statusCode,
    required this.timestamp,
    required this.items,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      statusCode: json['statusCode'] as int,
      timestamp: json['timestamp'] as String,
      items: ResponseItems<T>.fromJson(
        json['data'] as Map<String, dynamic>,
        fromJsonT,
      ),
    );
  }
}

class ResponseItems<T> {
  final List<T> data;
  final ResponseMetadata metadata;

  ResponseItems({required this.data, required this.metadata});

  factory ResponseItems.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ResponseItems<T>(
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      metadata: ResponseMetadata.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }
}

class ResponseMetadata {
  final int total;
  final int page;
  final int totalPage;

  ResponseMetadata({
    required this.total,
    required this.page,
    required this.totalPage,
  });

  factory ResponseMetadata.fromJson(Map<String, dynamic> json) {
    return ResponseMetadata(
      total: json['total'] as int,
      page: json['page'] as int,
      totalPage: json['totalPage'] as int,
    );
  }
}
