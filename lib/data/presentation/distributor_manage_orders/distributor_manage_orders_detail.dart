// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';

import 'package:carx/data/model/brand.dart';

import 'package:carx/data/model/car.dart';
import 'package:carx/data/model/delivery_address.dart';
import 'package:carx/data/model/order.dart';
import 'package:carx/data/model/order_management.dart';
import 'package:carx/data/presentation/distributor_manage_orders/bloc/manage_order_bloc.dart';
import 'package:carx/data/presentation/distributor_manage_orders/bloc/manage_order_event.dart';
import 'package:carx/data/presentation/distributor_manage_orders/bloc/manage_order_state.dart';
import 'package:carx/data/reponsitories/order/order_reponsitory_impl.dart';
import 'package:carx/loading/box_loading.dart';

import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';

import 'package:carx/utilities/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ManageOrdersDetail extends StatefulWidget {
  const ManageOrdersDetail({super.key});

  @override
  State<ManageOrdersDetail> createState() => _ManageOrdersDetailState();
}

class _ManageOrdersDetailState extends State<ManageOrdersDetail> {
  late OrderManagement orderManagement;
  late Car car;
  late Brand brand;
  late Order _order;
  late DeliveryAddress deliveryAddress;
  late CountdownTimerController countdownController;
  late int endTime;
  late ManageOrderBloc _manageOrderBloc;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    orderManagement =
        ModalRoute.of(context)?.settings.arguments as OrderManagement;

    car = orderManagement.car;
    brand = orderManagement.brand;
    _order = orderManagement.order;
    deliveryAddress = orderManagement.deliveryAddress;
    endTime = DateTime.parse(_order.endTime!).millisecondsSinceEpoch;
    countdownController = CountdownTimerController(endTime: endTime);
    _manageOrderBloc = ManageOrderBloc(OrderReponsitoryImpl.response())
      ..add(GetOrderDataEvent(order: _order));
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
      body: BlocProvider(
        create: (context) => _manageOrderBloc,
        child: BlocConsumer<ManageOrderBloc, ManageOrderState>(
          listener: (context, state) {
            if (state.status == ManageOrderStatus.loading) {
              BoxLoading().show(context: context);
            } else if (state.status == ManageOrderStatus.success) {
              BoxLoading().hide();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                'Cập nhật trạng thái đơn đặt xe thành công!',
                style:
                    AppText.bodySmall.copyWith(color: AppColors.colorSuccess),
              )));
            } else {
              BoxLoading().hide();
            }
          },
          builder: (context, state) {
            if (state.order != null) {
              Order order = state.order!;
              return WillPopScope(
                onWillPop: () async {
                  Navigator.pop(context, true);
                  return false;
                },
                child: SingleChildScrollView(
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
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: CountdownTimer(
                                            controller: countdownController,
                                            endTime: endTime,
                                            widgetBuilder: (_, time) {
                                              if (time == null ||
                                                  order.status == 'Cancelled' ||
                                                  order.status == 'Completed') {
                                                return const Text(
                                                  'Đã kết thúc',
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
                        color: AppColors.lightGray,
                        child: const Text(
                          'THỜI GIAN THUÊ',
                          style: AppText.subtitle1,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
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
                        padding: EdgeInsets.all(12),
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
                        color: AppColors.lightGray,
                        child: const Text(
                          'ĐỊA CHỈ GIAO XE',
                          style: AppText.subtitle1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Tên khách hàng: ',
                                    style: AppText.body2,
                                  ),
                                  TextSpan(
                                      text: '${deliveryAddress.recipientName}'),
                                ],
                                style: AppText.subtitle3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Địa chỉ giao xe: ',
                                    style: AppText.body2,
                                  ),
                                  TextSpan(text: '${deliveryAddress.address}'),
                                ],
                                style: AppText.subtitle3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Text(
                                  'SDT: ',
                                  style: AppText.body2,
                                ),
                                Text(
                                  deliveryAddress.phone ?? 'Default',
                                  style: AppText.subtitle3,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        color: Color(0xffe0e3e7),
                        child: const Text(
                          'CHI TIẾT THANH TOÁN',
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
                            horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Mã đơn đặt xe',
                              style: AppText.body2,
                            ),
                            Text(
                              '#${order.code}',
                              style: AppText.subtitle3,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Trạng thái thanh toán',
                              style: AppText.body2,
                            ),
                            Text(
                              '${order.paymentstatus}',
                              style: AppText.subtitle3.copyWith(
                                color: order.paymentstatus == 'Unpaid'
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Số lượng xe đặt',
                              style: AppText.body2,
                            ),
                            Text(
                              '${order.quantity} xe',
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
                              'Cost',
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
                              'Tổng tiền thanh toán',
                              style: AppText.body2,
                            ),
                            Text(
                              formattedAmountCar(order.totalAmount!),
                              style: AppText.subtitle3,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: order.status == 'Chờ xác nhận',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _manageOrderBloc.add(
                                        UpdateOrderEvent(status: 'Đã hủy'));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.red,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          side: const BorderSide(
                                              color: Colors.red, width: 1)),
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 4, 4, 4)),
                                  child: const Text('Từ chối'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _manageOrderBloc.add(
                                        UpdateOrderEvent(status: 'Đang giao'));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: AppColors.colorSuccess,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          side: const BorderSide(
                                              color: AppColors.colorSuccess,
                                              width: 1)),
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 4, 4, 4)),
                                  child: const Text('Xác nhận và giao xe'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: order.status == 'Đang giao',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _manageOrderBloc.add(
                                        UpdateOrderEvent(status: 'Đã hủy'));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.red,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          side: const BorderSide(
                                              color: Colors.red, width: 1)),
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 4, 4, 4)),
                                  child: const Text('Giao xe thất bại'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _manageOrderBloc.add(
                                        UpdateOrderEvent(status: 'Đang thuê'));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: AppColors.colorSuccess,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          side: const BorderSide(
                                              color: AppColors.colorSuccess,
                                              width: 1)),
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 4, 4, 4)),
                                  child: const Text('Giao xe thành công'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: order.status == 'Đang thuê',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _manageOrderBloc.add(
                                        UpdateOrderEvent(status: 'Đã hủy'));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.red,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          side: const BorderSide(
                                              color: Colors.red, width: 1)),
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 4, 4, 4)),
                                  child: const Text('Báo cáo sự cố'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _manageOrderBloc.add(UpdateOrderEvent(
                                        status: 'Đã hoàn thành'));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: AppColors.colorSuccess,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          side: const BorderSide(
                                              color: AppColors.colorSuccess,
                                              width: 1)),
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4, 4, 4, 4)),
                                  child: const Text('Xác nhận hoàn thành'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
