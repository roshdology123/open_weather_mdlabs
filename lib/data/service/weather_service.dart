import 'package:dio/dio.dart';
import 'package:open_weather_mdlabs/data/model/weather_response.dart';
import '../api/api_client.dart';

class WeatherService {
  final ApiClient apiClient;
  static const String apiKey = "3d331ea0b43874985b74d3bd0f90748e";

  WeatherService(Dio dio) : apiClient = ApiClient(dio);

  Future<WeatherResponse?> fetchWeather(String cityName) async {
    try {
      final response = await apiClient.getWeather(
        cityName.trim(),
        apiKey,
        "metric",
      );
      return response;
    } on DioException catch (dioError) {
      throw _handleDioError(dioError);
    }
  }

  String _handleDioError(DioException dioError) {
    if (dioError.response != null) {
      switch (dioError.response!.statusCode) {
        case 400:
          return "Invalid city name. Please check and try again.";
        case 404:
          return "City not found. Please check the spelling.";
        case 500:
          return "Server error. Please try again later.";
        default:
          return "An error occurred: ${dioError.response!.statusCode}. Please try again.";
      }
    } else if (dioError.type == DioExceptionType.receiveTimeout) {
      return "Connection timeout. Please check your internet connection.";
    } else if (dioError.type == DioExceptionType.connectionError) {
      return "Network error. Please check your internet connection.";
    } else {
      return "An unexpected error occurred. Please try again.";
    }
  }
}
