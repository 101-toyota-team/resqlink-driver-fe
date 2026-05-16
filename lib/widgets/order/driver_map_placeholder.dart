import 'package:flutter/material.dart';

class DriverMapPlaceholder extends StatelessWidget {
  final String text;

  const DriverMapPlaceholder({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 40, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.grey, 
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }
}