import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/patient.dart';
import '../providers/patient_provider.dart';
import '../views/patient_details.dart';
import '../theme/app_theme.dart';

class PatientTile extends StatelessWidget {
  final Patient patient;
  const PatientTile({required this.patient, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      padding: AppTheme.tilePadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientDetailsPage(patient),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${patient.name} ${patient.surname}",
                  style: AppTheme.tileTitleStyle,
                ),
                Text(
                  patient.code,
                  style: AppTheme.tileSubtitleStyle,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              patient.starred ? Icons.star : Icons.star_border,
              color: AppTheme.primaryColor,
            ),
            onPressed: () => context.read<PatientModel>().toggleStarred(patient),
          ),
        ],
      ),
    );
  }
}
