import 'package:flutter/material.dart';
import 'package:mypatients/widgets/medication_tile.dart';
import '../theme/app_theme.dart';
import '../widgets/menu_lateral.dart'; // Importa el Drawer reutilizable
import 'package:provider/provider.dart';
import '../providers/medication_provider.dart';
import '../widgets/error_message.dart';

class MedicationPage extends StatelessWidget {
  const MedicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("My active medications"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textColorLight,
      ),
      drawer: const AppDrawer(), // Usa el Drawer reutilizable
      body: FutureBuilder(
        future: context.read<MedicationModel>().loadMedications(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorMessage(message: snapshot.error.toString());
          } else if (!snapshot.hasData &&
              context.watch<MedicationModel>().medications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final medications = context.watch<MedicationModel>().medications;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final medication = medications[index];
                return MedicationDetailsTile(
                  title: medication.name,
                  dosage: medication.dosage.toString(),
                  startDate: medication.startDate,
                  duration: medication.treatmentDuration.toString(),
                );
              },
            );
          }
        },
      ),
    );
  }
}
