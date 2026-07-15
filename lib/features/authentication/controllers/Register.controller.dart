import 'package:flutter_riverpod/legacy.dart';

final obscureRegPasswordProvider = StateProvider<bool>((ref) => true);
final obscureConfirmPasswordProvider = StateProvider<bool>((ref) => true);
final agreeTermsProvider = StateProvider<bool>((ref) => false);