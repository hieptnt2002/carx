class Car {
  final int id;
  final String name;
  final String image;
  final int price;
  final String brandName;
  final String brandLogo;
  final int quantity;
  final double? rating;
  final String? location;
  const Car({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.brandName,
    required this.brandLogo,
    required this.quantity,
    this.rating,
    this.location,
  });
  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: int.parse(json['id']),
        name: json['name'],
        image: json['image'],
        price: int.tryParse(json['price_per_day']) ?? 0,
        brandName: json['brand_name'],
        brandLogo: json['brand_image'],
        quantity: int.tryParse(json['quantity']) ?? 1,
        location: json['location'],
        rating: double.parse(json['rating'] ?? '0'),
      );
}
