class PeriodSpending {
  final String period;
  final double totalAmount;
  final int transactionCount;

  PeriodSpending({
    required this.period,
    required this.totalAmount,
    required this.transactionCount,
  });

  factory PeriodSpending.fromJson(Map<String, dynamic> json) {
    return PeriodSpending(
      period: json['period'] ?? '',
      totalAmount: double.parse(
        json['total_amount'].toString(),
      ),
      transactionCount: json['transaction_count'] ?? 0,
    );
  }
}