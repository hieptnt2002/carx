import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String content;
  final String createdAt;
  final int likes;
  final String poster;
  final String posterAvatar;
  final List<dynamic> imagesPost;

  const Post({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.poster,
    required this.posterAvatar,
    required this.imagesPost,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: int.parse(json['id']),
        content: json['content'],
        createdAt: json['created_at'],
        likes: int.parse(json['number_of_likes']),
        poster: json['poster'],
        posterAvatar: json['poster_avatar'],
        imagesPost: json['images'],
      );

  @override
  List<Object?> get props =>
      [id, content, createdAt, likes, poster, posterAvatar, imagesPost];
}
