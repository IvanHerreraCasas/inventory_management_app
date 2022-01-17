class Purchase {
  final String id;
  final int units;
  final String? productID;
  final String? categoryID;
  final String productName;
  final double productPrice;
  final DateTime date;

  const Purchase({
    required this.id,
    required this.units,
    required this.productID,
    required this.categoryID,
    required this.productName,
    required this.productPrice,
    required this.date,
  });

  factory Purchase.fromJson(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      units: map['units'],
      productID: map['product_id'],
      categoryID: map['category_id'],
      productName: map['product_name'],
      productPrice: map['product_price'],
      date: map['date']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'units': units,
      'product_id': productID,
      'category_id': categoryID,
      'product_name': productName,
      'product_price': productPrice,
      'date': date,
    };
  }

  double get total => units * productPrice;
}
