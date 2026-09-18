class CategorySpending {
  final String category;
  final int transactionCount;
  final double totalAmount;

  CategorySpending({
    required this.category,
    required this.transactionCount,
    required this.totalAmount,
  });

  factory CategorySpending.fromJson(Map<String, dynamic> json) {
    return CategorySpending(
      category: json['category'] ?? '',
      transactionCount: json['transaction_count'] ?? 0,
      totalAmount: double.parse(
        json['total_amount'].toString(),
      ),
    );
  }
}