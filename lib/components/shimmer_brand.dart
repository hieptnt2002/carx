import 'package:carx/utilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerBrand({required double size}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Shimmer.fromColors(
        baseColor: AppColors.lightGray.withOpacity(0.5),
        highlightColor: AppColors.lightGray,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(999)),
            color: AppColors.lightGray,
          ),
          width: size,
          height: size,
        ),
      ),
      const SizedBox(height: 4),
    ],
  );
}
