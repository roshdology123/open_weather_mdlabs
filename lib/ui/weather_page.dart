import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_weather_mdlabs/ui/widgets/custom_button.dart';
import 'package:open_weather_mdlabs/ui/widgets/weather_details.dart';

import '../data/model/weather_response.dart';
import '../data/service/weather_service.dart';
import 'widgets/custom_text_field.dart';

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
    final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
            title: 'Error',
            message: message,
            contentType: ContentType.failure));
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
            CustomTextField(cityController: _cityController),
            const SizedBox(height: 16),
            CustomButton(
              text: "Get Weather",
              onTap: _fetchWeather,
            ),
            const SizedBox(height: 16),
            if (_isLoading) _buildLoadingIndicator(),
            if (_weatherResponse != null)
              WeatherDetails(
                cityName: _weatherResponse!.name,
                temperature: _weatherResponse!.main.temp,
                condition: _weatherResponse!.weather[0].description,
                iconUrl:
                    "http://openweathermap.org/img/wn/${_weatherResponse!.weather[0].icon}@2x.png",
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
