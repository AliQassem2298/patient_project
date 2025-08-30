class Medicine {
  final int id;
  final String trade_name;
  final double price;
  final String? image; // صارت اختيارية

  Medicine({
    required this.id,
    required this.trade_name,
    required this.price,
    this.image,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] as int,
      trade_name: json['trade_name'] ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['image'], // إذا null تظل null
    );
  }
}
