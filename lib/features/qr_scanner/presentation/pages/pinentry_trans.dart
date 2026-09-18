import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/authentication/controllers/pin_controller.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/paymentsucceful_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/features/qr_scanner/presentation/pages/models/transfer_razo_model.dart';
import 'package:flutter_application_1/features/qr_scanner/presentation/repositeries/resolve_get.dart';


class PinEntryPage extends ConsumerStatefulWidget {
  final String toHandle;
  final double amount;
  final String categoryId;
  final String receiverName;

  const PinEntryPage({
    super.key,
    required this.toHandle,
    required this.amount,
    required this.categoryId,
    required this.receiverName,
  });

  @override
  ConsumerState<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends ConsumerState<PinEntryPage> {
  String pin = '';
  bool loading = false;

  void onKeyTap(String value) {
    if (loading) return;

    setState(() {
      if (pin.length < 6) {
        pin += value;
      }
    });

    if (pin.length == 6) {
      submitPin();
    }
  }

  void onBackspace() {
    if (pin.isEmpty || loading) return;
    setState(() {
      pin = pin.substring(0, pin.length - 1);
    });
  }

  Future<void> submitPin() async {
    setState(() => loading = true);

    try {
      final token = await ref
          .read(pinControllerProvider.notifier)
          .verifyPinWithBackend(pin);

      if (token == null) {
        throw Exception('Incorrect PIN');
      }

      final transfer = Transferrazomodel(
        toHandle: widget.toHandle,
        amount: widget.amount.toStringAsFixed(2),
        idempotencyKey: const Uuid().v4(),
        description: 'Payment',
        categoryId: widget.categoryId,
        transactionToken: token,
      );

     await createtransfer(transfer);

ref.read(pinControllerProvider.notifier).clearTransactionToken();

if (!mounted) return;

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => PaymentSuccessPage(
      amount: widget.amount,
    ),
  ),
);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Bkcolors.scaffoldbackground,
      appBar: AppBar(
        backgroundColor: Bkcolors.scaffoldbackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text('Enter PIN', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Paying ${widget.receiverName}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${widget.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                final filled = index < pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? Colors.deepPurpleAccent : Colors.white24,
                  ),
                );
              }),
            ),
            const Spacer(),
            if (loading)
              const CircularProgressIndicator()
            else
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  for (var i = 1; i <= 9; i++) _buildKey(i.toString()),
                  const SizedBox(),
                  _buildKey('0'),
                  IconButton(
                    onPressed: onBackspace,
                    icon: const Icon(Icons.backspace_outlined, color: Colors.white70),
                  ),
                ],
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildKey(String value) {
    return TextButton(
      onPressed: () => onKeyTap(value),
      child: Text(
        value,
        style: const TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}