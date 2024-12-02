import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../data/model/weather_response.dart';
import '../data/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService(Dio());
  WeatherResponse? _weatherResponse;
  bool _isLoading = false;

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
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
            if (_isLoading) _buildLoadingIndicator(),
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

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildWeatherDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "City: ${_weatherResponse!.name}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Temperature: ${_weatherResponse!.main.temp}°C",
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 8),
        Text(
          "Condition: ${_weatherResponse!.weather[0].description}",
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 16),
        Image.network(
          "http://openweathermap.org/img/wn/${_weatherResponse!.weather[0].icon}@2x.png",
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      ],
    );
  }
}
