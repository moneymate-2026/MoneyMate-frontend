import 'package:flutter_application_1/features/authentication/datasources/login_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinController extends StateNotifier<String?> {
  PinController() : super(null);

  static const String _pinKey = 'user_pin';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  String? _transactionToken;
  String? get transactionToken => _transactionToken;

  

    // saving the pin user entered ,not saving its like encrypting  
  Future<void> savePin(String pin) async {
    try {
      await _storage.write(key: _pinKey, value: 'true');
      state = pin;
    } catch (e) {
      print('Failed to save PIN: $e');
    }
  }


  // checking the pin stored then fetching the stored ,when the value have its return true ,its nothing return false;
  Future<bool> hasPin() async {
    try {
      final savedPin = await _storage.read(key: _pinKey);
      return savedPin != null;
    } catch (e) {
      print('Failed to check PIN: $e');
      return false;
    }
  }


       //verifying the pin , and the backend giving the token to complete verifying
  Future<String?> verifyPinWithBackend(String enteredPin) async {
    try {
      final result = await verifyPinApi(pin: enteredPin); 
      _transactionToken = result.transactionToken;
      return result.transactionToken;
    } catch (e) {
      print('PIN verification failed: $e');
      return null;
    }
  }

  void clearTransactionToken() {
    _transactionToken = null;
  }


    //only removing the encrypted flage not stored value
  Future<void> clearPin() async {
    try {
      await _storage.delete(key: _pinKey);
      state = null;
    } catch (e) {
      print('Failed to clear PIN: $e');
    }
  }
}

final pinControllerProvider = StateNotifierProvider<PinController, String?>(
  (ref) => PinController(),
);