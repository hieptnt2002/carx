import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_routes.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:carx/utilities/navigation_controller.dart';
import 'package:carx/features/model/brand.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemCategory extends StatelessWidget {
  final Brand brand;
  const ItemCategory({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.find();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            if (brand.name == 'Tất cả') {
              controller.updateItem(1);
            } else {
              Navigator.pushNamed(context, Routes.routeCarByBrand,
                  arguments: brand);
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(999)),
              color: AppColors.lightGray,
            ),
            padding: const EdgeInsets.all(12),
            child: CachedNetworkImage(
              imageUrl: brand.image,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            brand.name,
            style: AppText.bodyFontColor,
            maxLines: 1,
          ),
        )
      ],
    );
  }
}
