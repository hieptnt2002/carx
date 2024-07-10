// ignore_for_file: deprecated_member_use

import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/navigation_controller.dart';
import 'package:carx/features/presentation/categories/ui/categories_view.dart';
import 'package:carx/features/presentation/home/ui/home_view.dart';

import 'package:carx/features/presentation/personal/personal_view.dart';
import 'package:carx/features/presentation/notify/notification_screen.dart';
import 'package:carx/view/explore_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final MainController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(MainController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.currentItem.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            bottomNavigationItem(
              'assets/svg/home.svg',
              'Trang chủ',
              controller.currentItem.value,
              0,
            ),
            bottomNavigationItem(
              'assets/svg/categories.svg',
              'Danh mục',
              controller.currentItem.value,
              1,
            ),
            bottomNavigationItem(
              'assets/svg/explore.svg',
              'Bài đăng',
              controller.currentItem.value,
              2,
            ),
            bottomNavigationItem(
              'assets/svg/bell.svg',
              'Thông báo',
              controller.currentItem.value,
              3,
            ),
            bottomNavigationItem(
              'assets/svg/person.svg',
              'Cá nhân',
              controller.currentItem.value,
              4,
            ),
          ],
          currentIndex: controller.currentItem.value,
          onTap: (value) {
            controller.updateItem(value);
          },
          showUnselectedLabels: false,
          backgroundColor: AppColors.primary,
          fixedColor: AppColors.secondary,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  BottomNavigationBarItem bottomNavigationItem(
    String assetIcon,
    String label,
    int currentIndex,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assetIcon,
        color: currentIndex == index ? AppColors.secondary : Colors.white,
      ),
      label: label,
    );
  }
}

final pages = [
  const HomeView(),
  const CategoriesView(),
  const ExploreScreen(),
  const NotificationScreeen(),
  const PersonalView(),
];
