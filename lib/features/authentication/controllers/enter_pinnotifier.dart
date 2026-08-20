import 'package:flutter_application_1/features/authentication/controllers/enter_pin_state_controller.dart';
import 'package:flutter_riverpod/legacy.dart';


class EnterPinNotifier extends StateNotifier<EnterPinState> {
  EnterPinNotifier() : super(const EnterPinState());

  static const int pinLength = 6;

  void addDigit(String digit) {
    if (state.enteredPin.length >= pinLength) return;
    state = state.copyWith(
      enteredPin: state.enteredPin + digit,
      clearError: true,
    );
  }

  void deleteDigit() {
    if (state.enteredPin.isEmpty) return;
    state = state.copyWith(
      enteredPin: state.enteredPin.substring(0, state.enteredPin.length - 1),
      clearError: true,
    );
  }

  void clearPin() {
    state = state.copyWith(enteredPin: '', clearError: true);
  }

  void setBiometricError(String message) {
    state = state.copyWith(errorText: message);
  }
}

final enterPinProvider =
    StateNotifierProvider.autoDispose<EnterPinNotifier, EnterPinState>(
  (ref) => EnterPinNotifier(),
);