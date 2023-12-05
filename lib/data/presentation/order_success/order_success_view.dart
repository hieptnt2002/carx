import 'package:cached_network_image/cached_network_image.dart';

import 'package:carx/data/model/car.dart';
import 'package:carx/data/model/delivery_address.dart';
import 'package:carx/data/model/order.dart';
import 'package:carx/data/presentation/order_success/reviews_success_widget.dart';
import 'package:carx/utilities/app_colors.dart';

import 'package:carx/utilities/app_routes.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:carx/utilities/util.dart';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class OrderSucess extends StatefulWidget {
  const OrderSucess({super.key});

  @override
  State<OrderSucess> createState() => _OrderSucessState();
}

class _OrderSucessState extends State<OrderSucess>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Order order = arguments['order'];
    Car car = arguments['car'];
    DeliveryAddress deliveryAddress = arguments['address'];
    return Scaffold(
      body: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 5)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _animationController.forward();
              return SlideTransition(
                position: _slideAnimation,
                child: widgetMain(context, order, car, deliveryAddress),
              );
            } else {
              return const ReviewSuccessWidget();
            }
          }),
    );
  }

  Widget widgetMain(BuildContext context, Order order, Car car,
      DeliveryAddress deliveryAddress) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 48, 16, 16),
              color: AppColors.colorSuccess,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Navigator.of(context)
                          .pushNamedAndRemoveUntil(
                              Routes.routeMain, (route) => false),
                      child: Container(
                        width: 36,
                        height: 36,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: const Color(0x32FFFFFF),
                            borderRadius: BorderRadius.circular(999)),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_xlkxtmul.json',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      frameRate: FrameRate(60),
                      repeat: false,
                      animate: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Đã đặt hàng',
                    style: AppText.header.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Tổng tiền ',
                        ),
                        TextSpan(
                          text: formattedAmountCar(order.totalAmount!),
                        )
                      ],
                      style: AppText.subtitle3.copyWith(color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Color(0x1AFFFFFF),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car.name,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.subtitle3
                                    .copyWith(color: AppColors.white),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: CachedNetworkImage(
                                      imageUrl: car.brandLogo,
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.contain,
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/logo-dark.png',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    car.brandName,
                                    style: AppText.body2
                                        .copyWith(color: AppColors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${formattedAmountCar(car.price)}/ngày',
                                style: AppText.subtitle3
                                    .copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: CachedNetworkImage(
                            imageUrl: car.image,
                            height: 72,
                            width: 72,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xffe0e3e7),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      'CHI TIẾT GIAO XE',
                      style:
                          AppText.subtitle1.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  deliveryAddress.recipientName ?? 'Default',
                  style: AppText.subtitle3,
                ),
                const SizedBox(height: 4),
                Text(
                  deliveryAddress.address ?? 'Default',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.subtitle3.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Mobile: ',
                      style: AppText.body2,
                    ),
                    Text(
                      deliveryAddress.phone ?? 'Default',
                      style: AppText.body2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 24,
            thickness: 1,
            color: Color(0xffe0e3e7),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/truck.svg',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Dự kiến giao xe - Sẽ được cập nhật sớm!',
                  style: AppText.bodyFontColor,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.routeMain, (route) => false);
                    },
                    icon: SvgPicture.asset('assets/svg/home.svg', width: 24),
                    label: const Text(
                      'Quay về trang chủ',
                      style: AppText.subtitle3,
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xffe3e5e5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
