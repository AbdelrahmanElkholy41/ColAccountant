import '../../edit_Product/Modal/ProductModel.dart';

class SaleModel {
  final int id;
  final int productId;
  final int quantity;
  final double totalPrice;
  final double profit;
  final DateTime createdAt;
  final ProductModel product; // ← استبدل nameProduct

  SaleModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.profit,
    required this.createdAt,
    required this.product,
  });

  factory SaleModel.fromMap(Map<String, dynamic> map) {
    final productMap = map['Product'] ?? {};
    return SaleModel(
      id: map['id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      totalPrice: (map['total_price'] as num).toDouble(),
      profit: (map['profit'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
      product: ProductModel.fromMap(productMap),
    );
  }

  @override
  String toString() {
    return 'SaleModel { '
        'id: $id, '
        'productId: $productId, '
        'quantity: $quantity, '
        'totalPrice: $totalPrice, '
        'profit: $profit, '
        'createdAt: $createdAt, '
        'product: ${product.name} }';
  }
}
