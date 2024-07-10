class SliderImage {
  final String id;
  final String image;
  final String carId;
  const SliderImage({
    required this.id,
    required this.image,
    required this.carId,
  });
  factory SliderImage.fromJson(Map<String, dynamic> json) => SliderImage(
        id: json['id'],
        image: json['image'],
        carId: json['car_id'],
      );
}
