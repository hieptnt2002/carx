import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/features/model/brand.dart';
import 'package:carx/features/model/car.dart';
import 'package:carx/features/model/order.dart';
import 'package:carx/features/model/order_management.dart';

import 'package:carx/utilities/app_text.dart';
import 'package:carx/utilities/util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class CarItemBooking extends StatefulWidget {
  final OrderManagement orderManagement;

  const CarItemBooking({super.key, required this.orderManagement});

  @override
  State<CarItemBooking> createState() => _CarItemBookingState();
}

class _CarItemBookingState extends State<CarItemBooking> {
  late final Car car;
  late final Brand brand;
  late final Order order;
  late CountdownTimerController countdownController;
  late int endTime;
  @override
  void initState() {
    car = widget.orderManagement.car;
    brand = widget.orderManagement.brand;
    order = widget.orderManagement.order;

    endTime = DateTime.parse(order.endTime!).millisecondsSinceEpoch;
    countdownController = CountdownTimerController(endTime: endTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: const BoxDecoration(
        color: Color.fromARGB(26, 189, 188, 188),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xffe0e3e7),
                ),
                padding: const EdgeInsets.all(4),
                child: CachedNetworkImage(
                  imageUrl: car.image,
                  width: 54,
                  height: 54,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
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
                            style: AppText.body2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ID Order',
                style: AppText.body2,
              ),
              Text(
                '#${order.code}',
                style: AppText.body2.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng tiền',
                style: AppText.body2,
              ),
              Text(
                formattedAmountCar(order.totalAmount!),
                style: AppText.body2.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trạng thái',
                style: AppText.body2,
              ),
              Text(
                '${order.status}',
                style: AppText.body2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: getColorStatus(order.status ?? ''),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
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
                          'Đã kết thúc',
                          style: TextStyle(color: Colors.redAccent),
                        );
                      } else {
                        return Text(
                          '${time.days ?? 0}d ${time.hours ?? 0}h ${time.min ?? 0}m ${time.sec}s',
                          style: const TextStyle(color: Colors.redAccent),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Color getColorStatus(String status) {
    switch (status) {
      case 'Chờ xác nhận':
        return Colors.lightBlue;
      case 'Đang giao':
        return Colors.orange;
      case 'Đang thuê':
        return Colors.blue;
      case 'Đã hoàn thành':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
