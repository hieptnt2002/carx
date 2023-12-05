import 'dart:convert';
import 'dart:io';

import 'package:carx/data/client/dio_client.dart';
import 'package:carx/data/model/dio_response.dart';
import 'package:carx/data/model/post.dart';
import 'package:carx/data/reponsitories/posts/posts_reponsitory.dart';
import 'package:carx/utilities/api_constants.dart';
import 'package:dio/dio.dart';

class PostsReponsitoryImpl extends PostsReponsitory {
  final Dio _dio;

  PostsReponsitoryImpl(this._dio);
  factory PostsReponsitoryImpl.response() =>
      PostsReponsitoryImpl(DioClient.instance.dio);
  @override
  Future<int> addPost(String uId, String content) async {
    try {
      final response = await _dio.post(
        ADD_POST,
        data: FormData.fromMap({
          'user_id': uId,
          'content': content,
        }),
      );
      if (response.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(response.data));
        if (dioResponse.status == 'OK') {
          int postId = int.parse(dioResponse.data);
          return postId;
        }
      }
      return 0;
    } catch (e) {
      throw Exception('Error Sever ${e.toString()}');
    }
  }

  @override
  Future<void> addPostImage(int postId, File imageFile) async {
    try {
      final response = await _dio.post(
        ADD_POST_IMAGE,
        data: FormData.fromMap({
          'post_id': postId,
          'image': await MultipartFile.fromFile(imageFile.path),
        }),
      );
      if (response.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(response.data));
        if (dioResponse.status == 'OK') {
          print(dioResponse.data);
        }
      }
    } catch (e) {
      throw Exception('Error Sever ${e.toString()}');
    }
  }

  @override
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _dio.get(FETCH_POSTS);
      if (response.statusCode == 200) {
        DioReponse dioReponse = DioReponse.fromJson(jsonDecode(response.data));

        if (dioReponse.status == 'OK') {
          List<dynamic> reponseData = dioReponse.data;
          List<Post> posts =
              reponseData.map((json) => Post.fromJson(json)).toList();
          return posts;
        } else {
          return [];
        }
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception('Error Sever');
    }
  }
}
