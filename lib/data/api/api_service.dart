import 'package:dio/dio.dart';
import 'api_response.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
  }

  Future<ApiResponse<dynamic>> get(String url) async {
    try {
      final response = await _dio.get(url);
      return ApiResponse.success(response.data);
      
    } on DioException catch (e) {
      String errorMsg = _handleDioError(e);
      return ApiResponse.error(errorMsg);
      
    } catch (e) {
      return ApiResponse.error("An unexpected error occurred: $e");
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "Connection timed out. Please check your internet.";
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return "Server error ($statusCode). Please try again later.";
      case DioExceptionType.connectionError:
        return "No internet connection.";
      default:
        return "Something went wrong: ${error.message}";
    }
  }
}