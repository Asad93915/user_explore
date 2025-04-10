import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_explorer_app/app/config/api_url.dart';

import '../model/user_model.dart';


import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  Future<UserModel?> fetchUsers(int page) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiUrl.users}?page=$page"),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        // Handle different HTTP status codes
        final errorMessage = _handleStatusCode(response.statusCode);
        throw ApiException(message: errorMessage, statusCode: response.statusCode);
      }
    } on SocketException {
      throw ApiException(message: 'No internet connection. Please check your network settings.');
    } on http.ClientException {
      throw ApiException(message: 'Failed to connect to the server. Please try again.');
    } on TimeoutException {
      throw ApiException(message: 'Request timed out. Please check your internet connection.');
    } on FormatException {
      throw ApiException(message: 'Invalid data format received from server.');
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  String _handleStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your parameters.';
      case 401:
        return 'Unauthorized. Please authenticate.';
      case 403:
        return 'Forbidden. You don\'t have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. The server encountered a temporary error.';
      case 503:
        return 'Service unavailable. The server is temporarily unable to handle the request.';
      default:
        return 'Request failed with status code: $statusCode';
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}
