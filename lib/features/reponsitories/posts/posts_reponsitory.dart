import 'dart:io';

import 'package:carx/features/model/post.dart';

abstract class PostsReponsitory {
  Future<int> addPost(String uId, String content);
  Future<void> addPostImage(int postId, File imageFile);
  Future<List<Post>> fetchPosts();
}
