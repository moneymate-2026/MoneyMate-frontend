import 'package:flutter_riverpod/legacy.dart';

class CreatePinNotifier extends StateNotifier<String> {
  CreatePinNotifier() : super('');

  static const int pinLength = 4;

  void addDigit(String digit) {
    if (state.length >= pinLength) return;
    state = state + digit;
  }

  void deleteDigit() {
    if (state.isEmpty) return;
    state = state.substring(0, state.length - 1);
  }

  void reset() {
    state = '';
  }
}

final createPinProvider =
    StateNotifierProvider.autoDispose<CreatePinNotifier, String>(
  (ref) => CreatePinNotifier(),
);