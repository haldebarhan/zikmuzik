import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zikmuzik/core/services/biometric_service.dart'; // ou ton state management

class BiometricSetupScreen extends StatelessWidget {
  BiometricSetupScreen({super.key});

  final BiometricAuthService _biometricService = BiometricAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fingerprint, size: 100, color: Colors.blue),
            const SizedBox(height: 30),
            const Text(
              "Activez la biométrie",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Connectez-vous plus rapidement avec Face ID, empreinte ou PIN",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                final success = await _biometricService.enableBiometric();
                if (success) {
                  Get.offAllNamed('/home'); // ou ta route principale
                } else {
                  Get.snackbar(
                    "Info",
                    "Vous pouvez activer plus tard dans les paramètres",
                  );
                  Get.offAllNamed('/home');
                }
              },
              child: const Text("Activer la biométrie"),
            ),
            TextButton(
              onPressed: () => Get.offAllNamed('/home'),
              child: const Text("Plus tard"),
            ),
          ],
        ),
      ),
    );
  }
}
