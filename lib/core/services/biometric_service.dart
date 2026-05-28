import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final _auth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();

  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _biometricTypeKey = 'biometric_type';

  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _storage.read(key: _biometricEnabledKey);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate({
    String localizedReason = 'Authentifiez-vous pour continuer',
    bool biometricOnly = false,
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: biometricOnly,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException catch (e) {
      print('PlatformException LocalAuth: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('Erreur authentification biométrique: $e');
      return false;
    }
  }

  Future<bool> enableBiometric() async {
    final success = await authenticate(
      localizedReason: 'Activez la biométrie pour un accès rapide',
      biometricOnly: false, // Autorise PIN / pattern en fallback
    );

    if (success) {
      try {
        await _storage.write(key: _biometricEnabledKey, value: 'true');

        final availableBiometrics = await getAvailableBiometrics();
        String type = 'pin';

        if (availableBiometrics.contains(BiometricType.face)) {
          type = 'face';
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          type = 'fingerprint';
        }

        await _storage.write(key: _biometricTypeKey, value: type);
        return true;
      } catch (e) {
        print('Erreur lors de la sauvegarde biométrique: $e');
        return false;
      }
    }
    return false;
  }

  Future<void> disableBiometric() async {
    try {
      await _storage.delete(key: _biometricEnabledKey);
      await _storage.delete(key: _biometricTypeKey);
    } catch (e) {
      print('Erreur lors de la désactivation biométrique: $e');
    }
  }

  Future<String?> getBiometricType() async {
    try {
      return await _storage.read(key: _biometricTypeKey);
    } catch (e) {
      return null;
    }
  }
}
