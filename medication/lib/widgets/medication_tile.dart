import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MedicationDetailsTile extends StatelessWidget {
  final String title;
  final String dosage;
  final String startDate;
  final String duration;

  const MedicationDetailsTile({
    required this.title,
    required this.dosage,
    required this.startDate,
    required this.duration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.medical_services_outlined,
            color: AppTheme.primaryColor,
            size: 32.0,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.tileTitleStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text("Dosage: $dosage", style: AppTheme.tileSubtitleStyle),
                Text("Start Date: $startDate", style: AppTheme.tileSubtitleStyle),
                Text("Duration: $duration days", style: AppTheme.tileSubtitleStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
