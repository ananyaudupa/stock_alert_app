class StockAlert {
  final String companyName;
  final double price;
  final String action;
  final double threshold;

  StockAlert({
    required this.companyName,
    required this.price,
    required this.action,
    required this.threshold,
  });
}