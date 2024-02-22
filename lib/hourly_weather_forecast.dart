import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String timeText;
  final String value;
  final IconData icon;

const HourlyForecastItem(
      {super.key, required this.timeText, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 7,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              timeText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 10,
            ),
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16
              ),
            ),
          ],
        ),
      ),
    );
  }
}
