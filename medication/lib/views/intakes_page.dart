import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/intake_tile.dart';
import '../widgets/menu_lateral.dart';
import '../providers/posology_provider.dart';
import '../models/posology.dart';

class IntakesPage extends StatefulWidget {
  const IntakesPage({super.key});

  @override
  State<IntakesPage> createState() => _IntakesPageState();
}

class _IntakesPageState extends State<IntakesPage> {
  int _selectedHours = 6;

  // Mapas para rastrear los estados de selección y de tomados
  final Map<int, bool> selectedPosologies = {};
  final Map<int, bool> takenPosologies = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PosologyModel>().loadPosologiesPeriodic(context, _selectedHours);
    });
  }

  void _updateHours(int hours) {
    setState(() {
      _selectedHours = hours;
    });
    context.read<PosologyModel>().loadPosologiesPeriodic(context, hours);
  }

  // Confirmar selecciones
  Future<void> _confirmSelected() async {
    final selectedIds = selectedPosologies.entries
        .where((entry) => entry.value) // Solo seleccionados
        .map((entry) => entry.key)
        .toList();

    String respuesta = "";
    for (var posologyId in selectedIds) {
      respuesta += await context.read<PosologyModel>().registerIntake(context, posologyId);
      respuesta += "\n";

      // Marcar como tomado
      setState(() {
        takenPosologies[posologyId] = true;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                respuesta,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ],
        ),
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Limpiar las selecciones después de confirmar
    setState(() {
      selectedPosologies.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Intakes (${_selectedHours}h)"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textColorLight,
        actions: [
          PopupMenuButton<int>(
            onSelected: _updateHours,
            icon: const Icon(Icons.filter_alt),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 6, child: Text("Next 6 hours")),
              const PopupMenuItem(value: 12, child: Text("Next 12 hours")),
              const PopupMenuItem(value: 24, child: Text("Next 24 hours")),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<PosologyModel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (model.posologies.isEmpty) {
            return const Center(child: Text("No intakes for the selected range."));
          } else {
            final posologies = model.posologies;

            // Agrupar las posologías por día
            final Map<DateTime, List<Posology>> groupedPosologies = {};
            DateTime now = DateTime.now();
            for (var posology in posologies) {
              DateTime posologyDateTime = DateTime(
                now.year,
                now.month,
                now.day,
                posology.hour,
                posology.minute,
              );
              if (posologyDateTime.isBefore(now)) {
                posologyDateTime = posologyDateTime.add(const Duration(days: 1));
              }
              DateTime key = DateTime(
                  posologyDateTime.year, posologyDateTime.month, posologyDateTime.day);
              groupedPosologies.putIfAbsent(key, () => []);
              groupedPosologies[key]!.add(posology);
            }

            // Nombres de los días de la semana
            const weekDays = [
              "Monday",
              "Tuesday",
              "Wednesday",
              "Thursday",
              "Friday",
              "Saturday",
              "Sunday"
            ];

            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: groupedPosologies.entries.map((entry) {
                    final date = entry.key;
                    final dailyPosologies = entry.value;

                    // Comparar si la fecha es el día actual
                    final isToday = DateTime.now().year == date.year &&
                        DateTime.now().month == date.month &&
                        DateTime.now().day == date.day;

                    // Mostrar "Today" si es hoy, o el nombre del día si no
                    final headerText = isToday
                        ? "Today"
                        : weekDays[date.weekday - 1]; // Restar 1 porque weekday es 1-based

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            headerText,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        ...dailyPosologies.map((posology) {
                          final isSelected = selectedPosologies[posology.id] ?? false;
                          final isTaken = takenPosologies[posology.id] == true;

                          return GestureDetector(
                            onTap: () {
                              if (!isTaken) {
                                setState(() {
                                  selectedPosologies[posology.id] = !(selectedPosologies[posology.id] ?? false);
                                });
                              }
                            },
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                IntakeDetailsTile(
                                  time:
                                  "${posology.hour.toString().padLeft(2, '0')}:${posology.minute.toString().padLeft(2, '0')}",
                                  medicationInfo: model.getMedicationNameByPosology(posology.id),
                                ),
                                if (!isTaken)
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedPosologies[posology.id] = value ?? false;
                                      });
                                    },
                                  ),
                                if (isTaken)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 16.0),
                                    child: Icon(Icons.check, color: Colors.green),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ),
                // Botón flotante para confirmar las selecciones
                if (selectedPosologies.values.any((isSelected) => isSelected))
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: FloatingActionButton.extended(
                      onPressed: _confirmSelected,
                      icon: const Icon(Icons.check),
                      label: const Text("Confirm"),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }

}
