import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/features/model/post.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: CachedNetworkImage(
                    imageUrl: post.posterAvatar,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/China-Construction-Bank.png',
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.poster,
                      style: AppText.subtitle3,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                      createAt(post.createdAt),
                      style: AppText.body2.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              post.content,
              style: AppText.body2,
              textAlign: TextAlign.justify,
            ),
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: post.imagesPost.length == 1 ? 1 : 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                mainAxisExtent: 200),
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: post.imagesPost[index]['image'],
                errorWidget: (context, url, error) {
                  return Image.asset('assets/images/logo-dark.png');
                },
              );
            },
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: post.imagesPost.length,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${post.likes} likes',
                  style: AppText.bodyFontColor,
                  textAlign: TextAlign.justify,
                ),
                const Text(
                  '1 bình luận',
                  style: AppText.bodyFontColor,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          const Divider(
            height: 24,
            thickness: 1,
            color: AppColors.lightGray,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(
                        Icons.thumb_up,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Thích',
                        style: AppText.bodyFontColor,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(
                        Icons.message_rounded,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Bình luận',
                        style: AppText.bodyFontColor,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: const Row(
                    children: [
                      Icon(
                        Icons.share,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Chia sẻ',
                        style: AppText.bodyFontColor,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String createAt(String dataTime) {
    DateTime parsedDateTime = DateTime.parse(dataTime);
    DateTime currentDateTime = DateTime.now();

    Duration difference = currentDateTime.difference(parsedDateTime);

    int hours = difference.inHours;
    int days = difference.inDays;

    String timeDifference = '';

    if (hours < 1 && days < 1) {
      int minutes = difference.inMinutes;
      timeDifference = '$minutes phút';
    } else if (days < 1) {
      timeDifference = '$hours giờ';
    } else {
      timeDifference = '$days ngày';
    }
    return timeDifference;
  }
}
