import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class ReviewSuccessWidget extends StatelessWidget {
  const ReviewSuccessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.green),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets10.lottiefiles.com/packages/lf20_xlkxtmul.json',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            frameRate: FrameRate(60),
            repeat: false,
            animate: true,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Thank you!',
              style: AppText.header.copyWith(color: AppColors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Đơn hàng của bạn đã được đặt!',
              textAlign: TextAlign.center,
              style: AppText.subtitle3.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
