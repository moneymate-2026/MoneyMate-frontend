class Walletmodels {
  final double balance;
  final String currency;

  Walletmodels({
    required this.balance,
    required this.currency,
  });

  factory Walletmodels.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final wallet = data['wallet'];

    return Walletmodels(
      balance: double.parse(data['total_balance'] as String),
      currency: wallet['currency'] as String,
    );
  }
}