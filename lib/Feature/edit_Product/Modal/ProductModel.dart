// Feature/edit_Product/Modal/ProductModel.dart


class ProductModel {
  final int id;
  final String name;
   int count;
  final double cost;
  final double price;
  final String imageUrl;
  final String description;

  ProductModel(   {
    required this.id,
    required this.name,
    required this.count,
    required this.price,
    required this.imageUrl,
    required this.cost,
    required this.description
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int? ?? 0, // الآن سيأتي من السيرفر
      name: map['Name'] as String? ?? '',
      count: map['Count'] as int? ?? 0,
      price: (map['Price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['Image'] as String? ?? '',
      description: map['Description'] as String? ?? '',
      cost:(map['Cost'] as num?)?.toDouble() ?? 0.0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      // لا ترسل id مطلقاً
      'Name': name,
      'Count': count,
      'Price': price,
      'Image': imageUrl,
      'Description':description,
      'Cost':cost
    };
  }

  @override
  String toString() {
    return 'ProductModel{'

        'Name: "$name", '
        'Count: $count, '
        'Price: $price, '
        'Image: "$imageUrl"'
        'Description: "$description"'
        'Cost: "$cost"'

        '}';
  }

  // Optional: Add copyWith method for easy modifications
  ProductModel copyWith({
    int? id,
    String? name,
    int? count,
    double? cost,
    double? price,
    String? imageUrl,
    String? description,

  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      count: count ?? this.count,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description?? this.description,
      cost: cost ?? this.cost
    );
  }
}