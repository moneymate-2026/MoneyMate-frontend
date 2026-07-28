import 'package:local_auth/local_auth.dart';
/// Handles fingerprint / Face ID authentication using device biometrics.
class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if this device supports biometrics (fingerprint/face)
  /// and has it set up.
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (e) {
      return false;
    }
  }

  /// Show the fingerprint/face prompt. Returns true if user
  /// successfully authenticated.
Future<bool> authenticate() async {
  try {
    return await _localAuth.authenticate(
      localizedReason: 'Unlock MoneyMate',
      biometricOnly: true,
    );
  } catch (e) {
    return false;
  }
}
}