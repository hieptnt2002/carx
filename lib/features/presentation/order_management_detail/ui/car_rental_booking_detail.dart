// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';

import 'package:carx/features/presentation/order_management_detail/bloc/order_management_detail_bloc.dart';
import 'package:carx/features/presentation/order_management_detail/bloc/order_management_detail_event.dart';
import 'package:carx/features/presentation/order_management_detail/bloc/order_management_detail_state.dart';
import 'package:carx/features/model/brand.dart';

import 'package:carx/features/model/car.dart';
import 'package:carx/features/model/delivery_address.dart';
import 'package:carx/features/model/order.dart';
import 'package:carx/features/model/order_management.dart';

import 'package:carx/features/reponsitories/order/order_reponsitory_impl.dart';
import 'package:carx/loading/loading.dart';

import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';

import 'package:carx/utilities/dialog/cancel_order_dialog.dart';
import 'package:carx/utilities/dialog/rating_vote_dialog.dart';
import 'package:carx/utilities/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarRentalBookingDetail extends StatefulWidget {
  const CarRentalBookingDetail({super.key});

  @override
  State<CarRentalBookingDetail> createState() => _CarRentalBookingDetailState();
}

class _CarRentalBookingDetailState extends State<CarRentalBookingDetail> {
  late OrderManagement orderManagement;
  late Car car;
  late Brand brand;
  late Order order;
  late DeliveryAddress deliveryAddress;
  late CountdownTimerController countdownController;
  late int endTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    orderManagement =
        ModalRoute.of(context)?.settings.arguments as OrderManagement;
    car = orderManagement.car;
    brand = orderManagement.brand;
    order = orderManagement.order;
    deliveryAddress = orderManagement.deliveryAddress;
    endTime = DateTime.parse(order.endTime!).millisecondsSinceEpoch;
    countdownController = CountdownTimerController(endTime: endTime);
  }

  @override
  void dispose() {
    countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Đơn Thuê Xe'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, false);
          return false;
        },
        child: BlocProvider(
          create: (context) => OrderManagementDetailBloc(
            OrderReponsitoryImpl.response(),
          ),
          child: BlocConsumer<OrderManagementDetailBloc,
              OrderManagementDetailState>(
            listener: (context, state) {
              if (state is OrderLoadingCancelState) {
                Loading().show(context: context);
              } else if (state is OrderCancelledSuccessState) {
                Loading().hide();
                Navigator.pop(context, true);
              } else if (state is OrderCancelledFailureState) {
                Loading().hide();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Không thể hủy do lỗi!')));
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: car.name,
                                        style: AppText.subtitle1,
                                      ),
                                      TextSpan(
                                        text: ' x${order.quantity ?? 1}',
                                        style: AppText.subtitle2,
                                      ),
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: brand.image,
                                      width: 24,
                                      height: 24,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        brand.name,
                                        style: AppText.bodyPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_filled_rounded,
                                        color: Colors.redAccent,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: CountdownTimer(
                                          controller: countdownController,
                                          endTime: endTime,
                                          widgetBuilder: (_, time) {
                                            if (time == null ||
                                                order.status == 'Cancelled' ||
                                                order.status == 'Completed') {
                                              return const Text(
                                                'Finished',
                                                style: TextStyle(
                                                    color: Colors.redAccent),
                                              );
                                            } else {
                                              return Text(
                                                '${time.days ?? 0}d ${time.hours ?? 0}h ${time.min ?? 0}m ${time.sec}s ',
                                                style: const TextStyle(
                                                    color: Colors.redAccent),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: const BoxDecoration(),
                            padding: const EdgeInsets.all(4),
                            child: CachedNetworkImage(
                              imageUrl: car.image,
                              height: 64,
                              width: 64,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xffe0e3e7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(text: 'MÃ ĐƠN HÀNG - '),
                                TextSpan(text: '#${order.code}'),
                              ],
                              style: AppText.subtitle1,
                            ),
                          ),
                          const Icon(
                            Icons.share_outlined,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            tracks.map((e) => itemTrack(context, e)).toList(),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: AppColors.lightGray,
                      child: const Text(
                        'CHI TIẾT GIAO HÀNG',
                        style: AppText.subtitle1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
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
                            style: AppText.subtitle3
                                .copyWith(color: AppColors.primary),
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: AppColors.lightGray,
                      child: const Text(
                        'THỜI GIAN THUÊ',
                        style: AppText.subtitle1,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bắt đầu',
                            style: AppText.body2,
                          ),
                          Text(
                            '${order.startTime}',
                            style: AppText.body2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kết thúc',
                            style: AppText.body2,
                          ),
                          Text(
                            '${order.endTime}',
                            style: AppText.body2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xffe0e3e7),
                      child: const Text(
                        'CHI TIẾT GIÁ',
                        style: AppText.subtitle1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xffe0e3e7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                'assets/svg/payment.svg',
                                width: 48,
                                height: 48,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              '${order.paymentMethods}',
                              style: AppText.subtitle3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tiền đặt xe',
                            style: AppText.body2,
                          ),
                          Text(
                            formattedAmountCar(order.amount!),
                            style: AppText.subtitle3,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Phí giao xe',
                            style: AppText.body2,
                          ),
                          Text(
                            formattedAmountCar(order.deliveryCharges ?? 0),
                            style: AppText.subtitle3
                                .copyWith(color: AppColors.colorSuccess),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Voucher giảm giá',
                            style: AppText.body2,
                          ),
                          Text(
                            formattedAmountCar(
                                int.parse(order.discountAmount ?? '0')),
                            style: AppText.subtitle3,
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Color(0xffe0e3e7),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng cộng',
                            style: AppText.subtitle3,
                          ),
                          Text(
                            formattedAmountCar(order.totalAmount!),
                            style: AppText.subtitle3,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: order.status != 'Đã hủy' &&
                                order.status != 'Đã hoàn thành',
                            child: Expanded(
                              child: SizedBox(
                                height: 45,
                                child: InkWell(
                                  onTap: () async {
                                    final isCancelled =
                                        await showCancelOrderDialog(
                                      context: context,
                                      title: 'Hủy Đặt xe',
                                      content:
                                          'Bạn có muốn hủy đơn đặt thuê xe của bạn?',
                                    );
                                    if (isCancelled) {
                                      context
                                          .read<OrderManagementDetailBloc>()
                                          .add(OrderCancellationEvent(
                                              order: order));
                                    }
                                  },
                                  overlayColor: const MaterialStatePropertyAll(
                                      Colors.transparent),
                                  child: Center(
                                    child: Text(
                                      'Hủy đặt xe',
                                      style: AppText.body2
                                          .copyWith(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: order.status == 'Đã hoàn thành',
                            child: Expanded(
                              child: SizedBox(
                                height: 45,
                                child: InkWell(
                                  onTap: () async {
                                    bool isReviews = await ratingVoteDialog(
                                        context, car, order.code!);
                                    if (isReviews) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Đánh giá của bạn đã được gửi!',
                                            style: TextStyle(
                                                color: AppColors.white),
                                          ),
                                          backgroundColor:
                                              AppColors.colorSuccess,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomLeft: Radius.circular(8)),
                                          ),
                                          duration: Duration(milliseconds: 800),
                                        ),
                                      );
                                    }
                                  },
                                  overlayColor: const MaterialStatePropertyAll(
                                      Colors.transparent),
                                  child: Center(
                                    child: Text(
                                      'Đánh giá',
                                      style: AppText.body2.copyWith(
                                          color: AppColors.colorSuccess),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: order.status != 'Đã hủy',
                            child: const SizedBox(
                              height: 22,
                              child: VerticalDivider(
                                width: 20,
                                thickness: 1,
                                color: Color(0xffe0e3e7),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              child: InkWell(
                                onTap: () {},
                                overlayColor: const MaterialStatePropertyAll(
                                    Colors.transparent),
                                child: Center(
                                  child: Text(
                                    'Hỗ trợ',
                                    style: AppText.body2
                                        .copyWith(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget itemTrack(BuildContext context, TrackOrder track) {
    final processes = track.processes;
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0xFF00AA07),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 77,
              decoration: const BoxDecoration(
                color: Color(0xFF00AA07),
              ),
            ),
            Visibility(
              visible: track == tracks[tracks.length - 1],
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF00AA07),
                  shape: BoxShape.circle,
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: const TextStyle(fontSize: 14),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                    child: Text(
                      track.processes![index],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF585858),
                      ),
                    ),
                  ),
                  itemCount: processes?.length,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final tracks = [
  TrackOrder(title: 'Rented', processes: [
    'Booking confirmed',
    'Distributor is handling vehicle reservations'
  ]),
  TrackOrder(title: 'Inprogress', processes: [
    'Accept car reservations',
    'Prepare to deliver the car to you'
  ]),
  TrackOrder(title: 'Shipped', processes: [
    'Vehicle is delivered',
  ]),
  TrackOrder(title: 'Completed', processes: [
    'Rental Successfully Completed',
    'The vehicle has been returned to the distributor'
  ]),
];

class TrackOrder {
  String title;
  List<String>? processes;
  TrackOrder({required this.title, this.processes});
}
