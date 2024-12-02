import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../data/model/weather_response.dart';
import '../data/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService(Dio());
  WeatherResponse? _weatherResponse;
  bool _isLoading = false;

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/lottie/sunny.json';
    }

    final condition = mainCondition.toLowerCase();

    if (['clouds', 'mist', 'smoke', 'haze', 'dust', 'fog']
        .any((element) => condition.contains(element))) {
      return 'assets/lottie/cloud.json';
    } else if (['rain', 'drizzle', 'shower rain']
        .any((element) => condition.contains(element))) {
      return 'assets/lottie/rain.json';
    } else if (['thunderstorm'].any((element) => condition.contains(element))) {
      return 'assets/lottie/thunder.json';
    } else if (['clear'].any((element) => condition.contains(element))) {
      return 'assets/lottie/sunny.json';
    } else {
      return 'assets/lottie/sunny.json';
    }
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _weatherResponse = null;
    });

    try {
      final response = await _weatherService.fetchWeather(_cityController.text);
      setState(() {
        _weatherResponse = response;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage(error.toString());
    }
  }

  void _showErrorMessage(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: "Error",
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCityInput(),
            const SizedBox(height: 16),
            _buildGetWeatherButton(),
            const SizedBox(height: 16),
            if (_isLoading) _buildLoadingWidget(),
            if (_weatherResponse != null) _buildWeatherDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildCityInput() {
    return TextField(
      controller: _cityController,
      decoration: InputDecoration(
        labelText: "Enter City Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.location_city),
      ),
    );
  }

  Widget _buildGetWeatherButton() {
    return ElevatedButton(
      onPressed: _fetchWeather,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text("Get Weather", style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildLoadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        const Text("Getting weather data...", style: TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildWeatherDetails() {
    final weather = _weatherResponse!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${weather.main.temp.round()}°C",
          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
        ),
        Text(
          weather.name,
          style: const TextStyle(fontSize: 30),
        ),
        const SizedBox(height: 20),
        Text(
          weather.weather.first.description,
          style: const TextStyle(fontSize: 30),
        ),
        const SizedBox(height: 20),
        Lottie.asset(getWeatherAnimation(weather.weather.first.description),
            width: 150, height: 150),
        const SizedBox(height: 20),
      ],
    );
  }
}
