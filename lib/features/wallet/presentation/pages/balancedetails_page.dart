import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/data/repositeries/wallet_get.dart';



class BalanceDetailPage extends StatefulWidget {
    final String transactionToken;
   BalanceDetailPage({super.key, required this.transactionToken});

  @override
  State<BalanceDetailPage> createState() => _BalanceDetailPageState();
}

class _BalanceDetailPageState extends State<BalanceDetailPage> {
  bool _isLoading = true;
  String? _error;
  double? _balance;

  @override
  void initState() {
    super.initState();
    _fetchBalance(); 
  }

  Future<void> _fetchBalance() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final wallet = await getWallet(transactionToken: widget.transactionToken);
      setState(() {
        _balance = wallet.balance;
        _isLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.response?.statusCode == 401
            ? 'Session expired. Please log in again.'
            : 'Failed to fetch balance.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Something went wrong. Check your connection.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Balance'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildContent(context),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Back'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 90,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Column(
        children: [
          Icon(Icons.error_outline, size: 32, color: Colors.red.shade400),
          const SizedBox(height: 12),
          Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          TextButton(onPressed: _fetchBalance, child: const Text('Retry')),
        ],
      );
    }

    return Column(
      children: [
        const Icon(
          Icons.account_balance_wallet_outlined,
          size: 36,
          color: Colors.deepPurple,
        ),
        const SizedBox(height: 12),
        Text(
          'Total Balance',
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '₹${_balance!.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}