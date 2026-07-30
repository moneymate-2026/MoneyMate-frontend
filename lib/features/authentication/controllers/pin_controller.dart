import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles saving, loading, and checking the user's PIN
/// using SharedPreferences (local storage).
class PinController extends StateNotifier<String?> {
  PinController() : super(null);

  static const String _pinKey = 'user_pin';

  /// Save the PIN to local storage.
  Future<void> savePin(String pin) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pinKey, pin);
      state = pin;
    } catch (e) {
      print('Failed to save PIN: $e');
    }
  }

  /// Load the saved PIN from local storage (null if none saved yet).
  Future<String?> loadPin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPin = prefs.getString(_pinKey);
      state = savedPin;
      return savedPin;
    } catch (e) {
      print('Failed to load PIN: $e');
      return null;
    }
  }

  /// Check if a PIN has already been created (used to decide
  /// whether to show Create PIN or Enter PIN screen).
  Future<bool> hasPin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_pinKey);
    } catch (e) {
      print('Failed to check PIN: $e');
      return false;
    }
  }

  /// Verify an entered PIN against the saved one.
  Future<bool> verifyPin(String enteredPin) async {
    try {
      final savedPin = await loadPin();
      return savedPin == enteredPin;
    } catch (e) {
      print('Failed to verify PIN: $e');
      return false;
    }
  }

  /// Clear the saved PIN (e.g. on logout).
  Future<void> clearPin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pinKey);
      state = null;
    } catch (e) {
      print('Failed to clear PIN: $e');
    }
  }
}

/// Riverpod provider — call this from UI via ref.read(pinControllerProvider.notifier)
final pinControllerProvider = StateNotifierProvider<PinController, String?>(
  (ref) => PinController(),
);