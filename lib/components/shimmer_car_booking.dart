import 'package:carx/utilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


  Widget shimmerCarBooking() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: const BoxDecoration(
        color: Color.fromARGB(26, 189, 188, 188),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.lightGray.withOpacity(0.5),
                highlightColor: AppColors.lightGray,
                child: Container(
                  width: 52.0,
                  height: 52.0,
                  color: AppColors.lightGray,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    load(),
                    const SizedBox(height: 6),
                    load(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(flex: 1, child: load()),
              const SizedBox(width: 30),
              Expanded(flex: 2, child: load()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(flex: 1, child: load()),
              const SizedBox(width: 30),
              Expanded(flex: 2, child: load()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(flex: 1, child: load()),
              const SizedBox(width: 30),
              Expanded(flex: 2, child: load()),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 144,
            child: load(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget load() {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGray.withOpacity(0.5),
      highlightColor: AppColors.lightGray,
      child: Container(
        height: 20,
        color: AppColors.lightGray,
      ),
    );
  }

