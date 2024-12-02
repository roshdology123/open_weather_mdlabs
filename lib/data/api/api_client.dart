import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../model/weather_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://api.openweathermap.org/data/3.0")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/weather")
  Future<WeatherResponse> getWeather(
    @Query("q") String cityName,
    @Query("appid") String apiKey,
    @Query("units") String units,
  );
}
