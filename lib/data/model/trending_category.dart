import 'package:equatable/equatable.dart';

class TrendingCategory extends Equatable {
  final String id;
  final String image;
  final String title;
  final String? description;
  const TrendingCategory(
      {required this.id,
      required this.image,
      required this.title,
      required this.description});
  factory TrendingCategory.fromJson(Map<String, dynamic> json) =>
      TrendingCategory(
          id: json['id'],
          image: json['image'],
          title: json['title'],
          description: json['description']);

  @override
  List<Object?> get props => [id, image, title, description];
}
