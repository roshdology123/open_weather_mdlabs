import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required TextEditingController cityController,
  }) : _cityController = cityController;

  final TextEditingController _cityController;

  @override
  Widget build(BuildContext context) {
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
}
