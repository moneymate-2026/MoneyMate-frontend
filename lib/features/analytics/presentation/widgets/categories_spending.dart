
class CategorySpending {
  final String name;
  final String iconKey; 
  final double amount;
  final double percentOfTotal; // 0.0 - 1.0

  const CategorySpending({
    required this.name,
    required this.iconKey,
    required this.amount,
    required this.percentOfTotal,
  });
}