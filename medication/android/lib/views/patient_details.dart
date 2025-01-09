import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/patient.dart';
import '../providers/patient_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/error_message.dart';

class PatientDetailsPage extends StatelessWidget {
  final Patient patient;
  const PatientDetailsPage(this.patient, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Patient Details"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textColorLight,
      ),
      body: FutureBuilder(
        future: context.read<PatientModel>().getPatientData(patient.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorMessage(message: snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final patientData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PatientDetailsTile(
                    title: "Name",
                    content: patientData.name,
                  ),
                  PatientDetailsTile(
                    title: "Surname",
                    content: patientData.surname,
                  ),
                  PatientDetailsTile(
                    title: "Code",
                    content: patientData.code,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Do something!"),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class PatientDetailsTile extends StatelessWidget {
  final String title;
  final String content;

  const PatientDetailsTile({
    required this.title,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.tilePadding,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.primaryColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTheme.tileTitleStyle),
          Row(
            children: [
              Text(content, style: AppTheme.tileSubtitleStyle),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
