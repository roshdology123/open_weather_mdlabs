import 'package:flutter/material.dart';

class WeatherDetails extends StatelessWidget {
  final String cityName;
  final double temperature;
  final String condition;
  final String iconUrl;

  const WeatherDetails({
    super.key,
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "City: $cityName",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Temperature: $temperature°C",
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 8),
        Text(
          "Condition: $condition",
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 16),
        Image.network(
          iconUrl,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      ],
    );
  }
}
