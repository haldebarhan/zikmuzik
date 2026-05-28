class ApiResponse<T> {
  final int statusCode;
  final String timestamp;
  final T data;

  ApiResponse({
    required this.statusCode,
    required this.timestamp,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      statusCode: json['statusCode'] as int,
      timestamp: json['timestamp'] as String,
      data: fromJsonT(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'statusCode': statusCode, 'timestamp': timestamp, 'data': data};
  }
}
