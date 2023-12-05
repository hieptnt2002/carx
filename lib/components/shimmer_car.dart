import 'package:carx/utilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerCar() {
  return InkWell(
    child: SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                baseColor: AppColors.lightGray.withOpacity(0.5),
                highlightColor: AppColors.lightGray,
                child: Image.asset(
                  'assets/images/logo-dark.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: AppColors.lightGray.withOpacity(0.5),
                  highlightColor: AppColors.lightGray,
                  child: Container(
                    height: 20,
                    color: AppColors.lightGray,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Shimmer.fromColors(
              baseColor: AppColors.lightGray.withOpacity(0.5),
              highlightColor: AppColors.lightGray,
              child: Container(
                height: 20,
                color: AppColors.lightGray,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 70,
            child: Shimmer.fromColors(
              baseColor: AppColors.lightGray.withOpacity(0.5),
              highlightColor: AppColors.lightGray,
              child: Container(
                height: 20,
                color: AppColors.lightGray,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
