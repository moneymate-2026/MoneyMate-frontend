

class EnterPinState {
  final String enteredPin;
  final String? errorText;
  final String? savedPin;

  const EnterPinState({
    this.enteredPin = '',
    this.errorText,
    this.savedPin,
  });

  EnterPinState copyWith({
    String? enteredPin,
    String? errorText,
    String? savedPin,
    bool clearError = false,
  }) {
    return EnterPinState(
      enteredPin: enteredPin ?? this.enteredPin,
      errorText: clearError ? null : (errorText ?? this.errorText),
      savedPin: savedPin ?? this.savedPin,
    );
  }
}
