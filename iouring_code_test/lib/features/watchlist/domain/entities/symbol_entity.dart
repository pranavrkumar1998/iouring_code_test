class SymbolEntity {
  final int id;
  final String name;
  final String exchange;
  final double price;
  final double change;
  final double percentageChange;

  SymbolEntity({
    required this.id,
    required this.name,
    required this.exchange,
    required this.price,
    required this.change,
    required this.percentageChange,
  });
}
