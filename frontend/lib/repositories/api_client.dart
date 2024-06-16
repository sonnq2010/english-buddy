import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? idToken,
  }) async {
    final response = await _dio.get(
      _baseUrl + path,
      options: makeOptions(idToken: idToken),
      queryParameters: queryParameters,
    );

    return response;
  }

  Future<Response> post(
    String path, {
    Object? body,
    String? idToken,
  }) async {
    final response = await _dio.post(
      _baseUrl + path,
      data: body,
      options: makeOptions(idToken: idToken),
    );

    return response;
  }

  Future<Response> put(
    String path, {
    Object? body,
    String? idToken,
  }) async {
    final response = await _dio.put(
      _baseUrl + path,
      data: body,
      options: makeOptions(idToken: idToken),
    );

    return response;
  }

  Future<Response> patch(
    String path, {
    Object? body,
    String? idToken,
  }) async {
    final response = await _dio.patch(
      _baseUrl + path,
      data: body,
      options: makeOptions(idToken: idToken),
    );

    return response;
  }

  Future<Response> delete(
    String path, {
    String? idToken,
  }) async {
    final response = await _dio.delete(
      _baseUrl + path,
      options: makeOptions(idToken: idToken),
    );

    return response;
  }
}
