class CarDetail {
  final int carId;
  final String image;
  final String name;
  final double pricePerDay;
  final int seats;
  final double topSpeed;
  final String engine;
  final double horsePower;
  final String descriptions;
  final String brandName;
  final String brandImage;

  const CarDetail(
      {required this.carId,
      required this.image,
      required this.name,
      required this.pricePerDay,
      required this.seats,
      required this.topSpeed,
      required this.engine,
      required this.horsePower,
      required this.descriptions,
      required this.brandName,
      required this.brandImage});

  factory CarDetail.fromJson(Map<String, dynamic> json) => CarDetail(
      carId: int.parse(json['car_id']),
      image: json['image'],
      name: json['name'],
      pricePerDay: double.parse(json['price_per_day']),
      seats: int.parse(json['seats']),
      topSpeed: double.parse(json['top_speed']),
      engine: json['engine'],
      horsePower: double.parse(json['horse_power']),
      descriptions: json['descriptions'],
      brandName: json['brand_name'],
      brandImage: json['brand_image']);
}
