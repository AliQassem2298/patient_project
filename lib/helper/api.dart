// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';

String baseUrlImage = 'http://127.0.0.1:8000';
String baseUrl = 'http://127.0.0.1:8000/api'; //////// windows

// String baseUrlImage = 'http://10.0.2.2:8000';
// String baseUrl = 'http://10.0.2.2:8000/api'; ///// emulator

// String baseUrlImage = 'http://192.168.27.48:8000';
// String baseUrl = 'http://192.168.27.48:8000/api'; ///// mobile

// String baseUrlImage = 'https://3b01-185-177-125-71.ngrok-free.app';
// String baseUrl = 'https://3b01-185-177-125-71.ngrok-free.app/api'; ///// server

class Api {
  final Dio _dio = Dio();

  // Optional: You can set default headers/baseUrl here
  Api() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<dynamic> get({
    required String url,
    String? token,
  }) async {
    try {
      Map<String, String> headers = {};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('GET url= $url, headers=$headers');

      Response response = await _dio.get(
        url,
        options: Options(headers: headers),
      );

      print('Response: ${response.data}');

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        final detail = response.data['detail'] ?? 'Unknown error';
        throw detail;
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<dynamic> post({
    required String url,
    dynamic body,
    String? token,
  }) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final data = body is String ? body : jsonEncode(body);

      print('POST url= $url, body=$data, headers=$headers');

      Response response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Response: ${response.data}');
        return response.data;
      } else {
        final detail = response.data['detail'] ?? 'Unknown error';
        throw detail;
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<dynamic> put({
    required String url,
    dynamic body,
    String? token,
  }) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('PUT url= $url, body=$body, token=$token');

      Response response = await _dio.put(
        url,
        data: body,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print('Response: ${response.data}');
        return response.data;
      } else {
        throw Exception(
          'There is a problem with status code ${response.statusCode}: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future<dynamic> delete({
    required String url,
    dynamic body,
    String? token,
  }) async {
    try {
      Map<String, String> headers = {};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('DELETE url= $url, body=$body, token=$token');

      Response response = await _dio.delete(
        url,
        data: body,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return null; // Success, no content
      } else {
        throw Exception(
          'There is a problem with status code ${response.statusCode}: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // Centralized error handler for Dio errors
  void _handleDioError(DioException e) {
    String message = 'Network error occurred';

    if (e.response != null) {
      // Server returned an error response (e.g., 4xx, 5xx)
      final responseData = e.response!.data;
      final detail = responseData is Map
          ? responseData['detail']
          : responseData.toString();
      message = detail ?? e.response!.statusMessage ?? message;
    } else {
      // Network-level or connection error
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          message = 'Request timed out';
          break;
        case DioExceptionType.connectionError:
          message = 'No internet connection or failed to connect to server';
          break;
        case DioExceptionType.badCertificate:
          message = 'SSL certificate error';
          break;
        case DioExceptionType.badResponse:
          message = 'Invalid response received';
          break;
        case DioExceptionType.cancel:
          message = 'Request was cancelled';
          break;
        case DioExceptionType.unknown:
        default:
          message = e.message ?? 'Unknown error occurred';
          break;
      }
    }

    print('API Error: $message');
    throw message;
  }
}
