import 'package:carx/components/item_post.dart';
import 'package:carx/components/shimmer_post.dart';
import 'package:carx/data/model/post.dart';
import 'package:carx/data/presentation/post/post_article_screen.dart';
import 'package:carx/data/reponsitories/posts/posts_repository_impl.dart';
import 'package:carx/utilities/app_colors.dart';

import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài đăng'),
      ),
      body: FutureBuilder(
        future: PostsReponsitoryImpl.response().fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Post> posts = snapshot.data!;
            return ListView.separated(
              itemBuilder: (context, index) {
                return PostItem(
                  post: posts[index],
                );
              },
              itemCount: posts.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 24,
                thickness: 12,
                color: AppColors.lightGray,
              ),
            );
          } else {
            return ListView.separated(
              itemBuilder: (context, index) {
                return shimmerPost();
              },
              itemCount: 9,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 24,
                thickness: 12,
                color: AppColors.lightGray,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostArticleScreen(),
              ));
        },
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.edit,
          size: 28,
        ),
      ),
    );
  }
}
