import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/patient_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/patient_tile.dart';
import '../widgets/error_message.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<StatefulWidget> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientModel>().loadPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("My Patients"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textColorLight,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            context.watch<PatientModel>().errorMessage != null
                ? ErrorMessage(
                message: context.watch<PatientModel>().errorMessage!)
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: context.watch<PatientModel>().patients.length,
              itemBuilder: (context, index) {
                return PatientTile(
                  patient: context.watch<PatientModel>().patients[index],
                );
              },
            ),
            if (context.watch<PatientModel>().isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            context.watch<PatientModel>().hasMorePatients
                ? Center(
              child: ElevatedButton(
                onPressed: () =>
                    context.read<PatientModel>().loadPatients(),
                child: const Text("Load more patients"),
              ),
            )
                : const Text("End of list", style: TextStyle(color: AppTheme.textColorDark)),
          ],
        ),
      ),
    );
  }
}
