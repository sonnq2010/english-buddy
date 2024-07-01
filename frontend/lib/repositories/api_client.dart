import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiResponse {
  const ApiResponse({
    required this.hasError,
    required this.errorCode,
    required this.message,
    required this.data,
  });

  final bool hasError;
  final int errorCode;
  final String message;
  final Map<String, dynamic> data;

  static ApiResponse? fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;

    return ApiResponse(
      hasError: json['hasError'] ?? false,
      errorCode: int.tryParse(json['errorCode'].toString()) ?? 0,
      message: json['message'] ?? '',
      data: json['appData'] ?? {},
    );
  }
}

class ApiClient {
  ApiClient._singleton();
  static final _instance = ApiClient._singleton();
  static ApiClient get I => _instance;

  final _baseUrl = '${dotenv.env['API_URL']}:${dotenv.env['API_PORT']}';
  final _dio = Dio();

  Options makeOptions({String? idToken}) {
    return Options(
      headers: {'Authorization': 'Bearer $idToken'},
    );
  }

  Future<ApiResponse?> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? idToken,
  }) async {
    final response = await _dio.get(
      _baseUrl + path,
      options: makeOptions(idToken: idToken),
      queryParameters: queryParameters,
    );

    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse?> post(
    String path, {
    Object? body,
    String? idToken,
  }) async {
    final response = await _dio.post(
      _baseUrl + path,
      data: body,
      options: makeOptions(idToken: idToken),
    );

    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse?> put(
    String path, {
    Object? body,
    String? idToken,
  }) async {
    final response = await _dio.put(
      _baseUrl + path,
      data: body,
      options: makeOptions(idToken: idToken),
    );

    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse?> patch(
    String path, {
    Object? body,
    String? idToken,
  }) async {
    final response = await _dio.patch(
      _baseUrl + path,
      data: body,
      options: makeOptions(idToken: idToken),
    );

    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse?> delete(
    String path, {
    String? idToken,
  }) async {
    final response = await _dio.delete(
      _baseUrl + path,
      options: makeOptions(idToken: idToken),
    );

    return ApiResponse.fromJson(response.data);
  }
}
