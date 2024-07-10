// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class CarReview extends Equatable {
  String id;
  double rating;
  String comment;
  String createdAt;
  int like;
  int dislike;
  String userId;
  String userName;
  CarReview({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.like,
    required this.dislike,
    required this.userId,
    required this.userName,
  });

  factory CarReview.fromJson(Map<String, dynamic> json) => CarReview(
        id: json['id'],
        rating: double.parse(json['rating']),
        comment: json['comment'] ?? '',
        createdAt: json['created_at'],
        like: int.parse(json['like']),
        dislike: int.parse(json['dislike']),
        userId: json['user_id'],
        userName: json['user_name'] ?? 'anonymous',
      );

  @override
  List<Object?> get props =>
      [id, rating, comment, createdAt, like, dislike, userId, userName];
}
