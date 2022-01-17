class Product {
  final String id;
  final String name;
  final double purchasePrice;
  final double salePrice;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.purchasePrice,
    required this.salePrice,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      purchasePrice: map['purchase_price'].toDouble(),
      salePrice: map['sale_price'].toDouble(),
      stock: map['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'purchase_price': purchasePrice,
      'sale_price': salePrice,
      'stock': stock,
    };
  }
}
