import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../main.dart';
import '../providers/patient_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientModel = context.read<PatientModel>();
      if (patientModel.selectedPatient != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainBottomNavigation()),
        );
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyCode() async {
    final patientModel = Provider.of<PatientModel>(context, listen: false);
    final code = _codeController.text;

    if (code.isEmpty || code.length != 11) {
      setState(() {
        _errorMessage = "Por favor ingresa un código válido.";
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final exists = await patientModel.getCodeExist(code);
      if (exists) {
        final patient = await patientModel.getPatientByCode(code);
        if (patient != null) {
          patientModel.selectedPatient = patient;
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainBottomNavigation()),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "Código no encontrado. Por favor verifica.";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error al verificar el código. Inténtalo más tarde.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 24),
                  _buildTitle(),
                  const SizedBox(height: 16),
                  _buildTextField(),
                  const SizedBox(height: 16),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 16),
                  _buildButton(),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      color: const Color(0xFFF7F9FC), // Fondo claro, asociado a limpieza y calma.
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF4A90E2),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.local_hospital_outlined,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "E-Saúde",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E3A59),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Introduce tu código de paciente",
      style: TextStyle(
        fontSize: 18,
        color: Color(0xFF6B7280),
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _codeController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _CodeInputFormatter(),
      ],
      maxLength: 11,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Código de paciente",
        hintText: "xxx-xx-xxxx",
        counterText: "",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF4A90E2)),
      ),
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: _verifyCode,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 2,
      ),
      child: const Text(
        "Acceso",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

/// Formateador personalizado para 'xxx-xx-xxxx'
class _CodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text;

    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');

    String formatted = '';
    for (int i = 0; i < digitsOnly.length && i < 9; i++) {
      if (i == 3 || i == 5) {
        formatted += '-';
      }
      formatted += digitsOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
