import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors.dart';
import 'package:flutter_application_1/core/theme/theme_controller.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/controllers/depo_controller.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/paymentsucceful_page.dart';
import 'package:flutter_application_1/features/wallet/presentation/pages/transaction_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMoneyPage extends ConsumerStatefulWidget {
  const AddMoneyPage({super.key, this.currentBalance = 2450.00});
  final double currentBalance;
  @override
  ConsumerState<AddMoneyPage> createState() {
    return _AddMoneyPageState();
  }
}

class _AddMoneyPageState extends ConsumerState<AddMoneyPage> {
  final TextEditingController _amountController = TextEditingController(text: '1000');
  bool _saveToSavings = true;
  double _allocation = 50;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double _getAmount() {
    double? amount = double.tryParse(_amountController.text);
    if (amount == null) return 0;
    return amount;
  }

  double _getSavingsAmount() {
    return _getAmount() * _allocation / 100;
  }
  Future<void> _onAddMoney() async {
  final amount = double.parse(_amountController.text);

  final token = await Navigator.push<String>(
    context,
    MaterialPageRoute(builder: (context) => const TransactionPinPage ()),
  );
  if (token == null) return; 

  setState(() => _isLoading = true);


  final controller = DepositController(
    onDepositSuccess: () {
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentSuccessPage(amount: amount)),
      );
    },
    onDepositError: (message) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    },
  );

  controller.startDeposit(amount.toInt(), transactionToken: token);
}



  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    Color borderColor = isDark ? Bkcolors.darkbordercolor : Bkcolors.lightbordercolor;
    Color backgroundColor = isDark ? Bkcolors.darkcardcolor : Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Add Money', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(),
            const SizedBox(height: 24),
            _buildAmountField(borderColor),
            const SizedBox(height: 24),
            _buildPaymentMethod(borderColor),
            const SizedBox(height: 20),
            _buildSavingsCard(),
            const SizedBox(height: 30),
            _buildAddMoneyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2E0854)]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Current Balance', style: TextStyle(color: Colors.white70)),
              Text('₹ ${widget.currentBalance.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 40),
        ],
      ),
    );
  }

  Widget _buildAmountField(Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter Amount', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              const Text('₹ ', style: TextStyle(fontSize: 20)),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  setState(() {
                    _amountController.clear();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Payment Method', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.credit_card, color: Colors.purple),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Pay using wallet balance', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.purple.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              const Text('Save to Savings ', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('(Optional)', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const Spacer(),
              Switch(
                value: _saveToSavings,
                activeColor: Colors.purple,
                onChanged: (value) {
                  setState(() {
                    _saveToSavings = value;
                  });
                },
              ),
            ],
          ),
          if (_saveToSavings) _buildSavingsDetails(),
        ],
      ),
    );
  }

  Widget _buildSavingsDetails() {
    double savingsAmount = _getSavingsAmount();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Allocation (${_allocation.round()}%)',
                style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.w600)),
            Text(savingsAmount.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
           Slider(
  value: _allocation,
  min: 0,
  max: 100,
  divisions: 4,
  activeColor: Colors.purple,
  onChanged: (value) {
    setState(() {
      _allocation = value;
    });
  },
),
        Text(
          "You'll save ${savingsAmount.toStringAsFixed(0)} towards your Emergency Fund.",
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildAddMoneyButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(  
        
        onPressed: _isLoading ? null : _onAddMoney,
        
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add Money', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            
      ),
    );
  }
}