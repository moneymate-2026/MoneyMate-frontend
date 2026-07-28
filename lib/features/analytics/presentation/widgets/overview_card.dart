
class SpendingOverview {
  final double totalSpending;
  final String comparisonLabel; // e.g. "vs April 2024"
  final double percentChange; // negative = spending went down
  final List<double> dailyOrWeeklyTotals; // for the bar chart
  final List<String> chartLabels; // e.g. ['1 May', '8 May', ...]
  final String highestSpendingCategory;
  final double highestSpendingAmount;
  final double averageDailySpend;

  const SpendingOverview({
    required this.totalSpending,
    required this.comparisonLabel,
    required this.percentChange,
    required this.dailyOrWeeklyTotals,
    required this.chartLabels,
    required this.highestSpendingCategory,
    required this.highestSpendingAmount,
    required this.averageDailySpend,
  });
}