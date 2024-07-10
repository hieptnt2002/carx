import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerPost() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Shimmer.fromColors(
                    baseColor: AppColors.lightGray.withOpacity(0.5),
                    highlightColor: AppColors.lightGray,
                    child: Container(
                      width: 52,
                      height: 52,
                      color: AppColors.lightGray,
                    )),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.lightGray.withOpacity(0.5),
                    highlightColor: AppColors.lightGray,
                    child: Container(
                      width: 177,
                      height: 16,
                      color: AppColors.lightGray,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Shimmer.fromColors(
                    baseColor: AppColors.lightGray.withOpacity(0.5),
                    highlightColor: AppColors.lightGray,
                    child: Container(
                      width: 111,
                      height: 16,
                      color: AppColors.lightGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Shimmer.fromColors(
          baseColor: AppColors.lightGray.withOpacity(0.5),
          highlightColor: AppColors.lightGray,
          child: Container(
            width: double.infinity,
            height: 200,
            color: AppColors.lightGray,
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 likes',
                style: AppText.bodyFontColor,
                textAlign: TextAlign.justify,
              ),
              Text(
                '0 comments',
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
                      'Like',
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
                      'Comment',
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
                      'Share',
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
