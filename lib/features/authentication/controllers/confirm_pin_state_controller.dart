import 'package:flutter_riverpod/legacy.dart';

class ConfirmPinState {
  final String enteredPin;
  final String? errorText;

  const ConfirmPinState({
    this.enteredPin = '',
    this.errorText,
  });

  ConfirmPinState copyWith({
    String? enteredPin,
    String? errorText,
    bool clearError = false,
  }) {
    return ConfirmPinState(
      enteredPin: enteredPin ?? this.enteredPin,
      errorText: clearError ? null : (errorText ?? this.errorText),
    );
  }
}

class ConfirmPinNotifier extends StateNotifier<ConfirmPinState> {
  ConfirmPinNotifier() : super(const ConfirmPinState());

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

  bool checkMatch(String originalPin) {
    if (state.enteredPin == originalPin) {
      return true;
    } else {
      state = state.copyWith(
        errorText: "PINs don't match. Try again.",
        enteredPin: '',
      );
      return false;
    }
  }
}

final confirmPinProvider =
    StateNotifierProvider.autoDispose<ConfirmPinNotifier, ConfirmPinState>(
  (ref) => ConfirmPinNotifier(),
);