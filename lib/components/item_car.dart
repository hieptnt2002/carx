// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/data/model/car.dart';
import 'package:carx/utilities/app_colors.dart';

import 'package:carx/utilities/app_routes.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:carx/utilities/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:shimmer/shimmer.dart';

class ItemCar extends StatelessWidget {
  final Car? car;
  const ItemCar({super.key, this.car});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (car != null) {
          String carId = ('${car?.id}');
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String> prefCarsId = prefs.getStringList('RE_CAR') ?? [];
          if (!prefCarsId.contains(carId)) {
            prefCarsId.add(carId);
          }
          prefs.setStringList('RE_CAR', prefCarsId);
          Navigator.pushNamed(context, Routes.routeCarDetail, arguments: car);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.black.withAlpha(22),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
              child: Text(
                '${car?.name}',
                style: AppText.bodyFontColor,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: CachedNetworkImage(
                      imageUrl: '${car?.brandLogo}',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/logo-dark.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${car?.brandName}',
                    style: AppText.bodyFontColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CachedNetworkImage(
                  placeholder: (context, url) {
                    return shimmerImageCar();
                  },
                  imageUrl: '${car?.image}',
                  height: 99,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      'assets/images/logo-dark.png',
                      height: 99,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: formattedAmountCar(car!.price),
                        style: AppText.subtitle2),
                    const TextSpan(text: '/ngày', style: AppText.bodyFontColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: AppColors.grey,
                          ),
                          Expanded(
                            child: Text(
                              car!.location!,
                              style: AppText.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      RatingBarIndicator(
                        direction: Axis.horizontal,
                        rating: car!.rating!,
                        itemCount: 5,
                        itemSize: 16,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star_rate_rounded,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                  width: 77,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      'Đặt ngay',
                      style:
                          AppText.bodyPrimary.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget shimmerImageCar() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.grey,
      child: Image.asset(
        'assets/images/logo-dark.png',
        height: 150,
        fit: BoxFit.contain,
      ),
    );
  }
}
