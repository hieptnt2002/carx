// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/data/presentation/order/select_address_widget.dart';

import 'package:carx/data/model/car.dart';
import 'package:carx/data/model/delivery_address.dart';

import 'package:carx/data/presentation/order/bloc/order_bloc.dart';
import 'package:carx/data/presentation/order/bloc/order_event.dart';
import 'package:carx/data/presentation/order/bloc/order_state.dart';
import 'package:carx/data/reponsitories/auth/auth_reponsitory_impl.dart';
import 'package:carx/loading/loading.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:carx/utilities/util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:intl/intl.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    final Car car = ModalRoute.of(context)!.settings.arguments as Car;

    return BlocProvider(
      create: (context) => OrderBloc(AuthReponsitoryImpl.reponsitory())
        ..add(FetchDeliveryAddressOrderEvent())
        ..add(DeliveryUpdated(15000))
        ..add(CarUpdated(car))
        ..add(PriceUpdated(car.price)),
      child: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.isLoading) {
            Loading().show(context: context);
          } else {
            Loading().hide();
          }
        },
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            appBar: AppBar(
              title: const Text('Đặt Xe'),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.chat))
              ],
            ),
            bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: AppColors.primary.withAlpha(50),
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedAmountCar(state.totalAmount),
                        style: AppText.title2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '0% off',
                        style: AppText.title2.copyWith(
                          color: AppColors.colorSuccess,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<OrderBloc>()
                          .add(OrderButtonClicked(context));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      fixedSize: const Size(130, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      side: const BorderSide(
                          width: 1, color: AppColors.lightGray),
                    ),
                    child:  Text(
                      'Tiếp tục',
                      style: AppText.subtitle2.copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            BlocBuilder<OrderBloc, OrderState>(
                              builder: (context, state) {
                                if (state.deliveryAddressStatus ==
                                    FetchDeliveryAddressStatus.loading) {
                                  return const CircularProgressIndicator();
                                } else if (state.deliveryAddressStatus ==
                                    FetchDeliveryAddressStatus.success) {
                                  DeliveryAddress? deliveryAddress =
                                      state.deliveryAddress;
                                  if (deliveryAddress == null) {
                                    return Text(
                                      'Chưa có địa chỉ giao(nhận) xe',
                                      style: AppText.subtitle1
                                          .copyWith(color: AppColors.grey),
                                    );
                                  } else {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                deliveryAddress.recipientName ??
                                                    'Default',
                                                style: AppText.subtitle3,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                deliveryAddress.address ??
                                                    'Default',
                                                overflow: TextOverflow.ellipsis,
                                                style: AppText.subtitle3
                                                    .copyWith(
                                                        color:
                                                            AppColors.primary),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Mobile: ',
                                                    style: AppText.body2,
                                                  ),
                                                  Text(
                                                    deliveryAddress.phone ??
                                                        'Default',
                                                    style: AppText.body2,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: AppColors.lightGray),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            deliveryAddress.type ?? 'Default',
                                            style: AppText.bodyFontColor,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                } else if (state.deliveryAddressStatus ==
                                    FetchDeliveryAddressStatus.failure) {
                                  return const Text('Error fetch data');
                                }
                                return Container();
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              height: 36,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: TextButton(
                                onPressed: () async {
                                  final result = await showModalBottomSheet(
                                    context: context,
                                    isDismissible: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(24),
                                          topRight: Radius.circular(24)),
                                    ),
                                    enableDrag: true,
                                    builder: (context) {
                                      return selectAddressWidget(
                                          context, state.deliveryAddress);
                                    },
                                  );
                                  if (result is DeliveryAddress) {
                                    context.read<OrderBloc>().add(
                                        UpdateDeliveryAddressOrderEvent(
                                            deliveryAddress: result));
                                  }
                                },
                                style: TextButton.styleFrom(
                                    side: const BorderSide(
                                        width: 1, color: Colors.black)),
                                child: Text(
                                  'Thay đổi địa chỉ',
                                  style: AppText.body2.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(26, 189, 188, 188),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: Color(0xffe0e3e7),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: CachedNetworkImage(
                              imageUrl: car.image,
                              height: 105,
                              width: 105,
                              fit: BoxFit.contain,
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
                                  style: AppText.subtitle3,
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
                                      style: AppText.bodyGrey,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${formattedAmountCar(car.price)}/ngày',
                                      style: AppText.subtitle3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            context.read<OrderBloc>().add(
                                                DecrementQuantityOrderEvent());
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              color: AppColors.lightGray,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: const Icon(
                                              Icons.remove,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 0, 8, 0),
                                          child: Text(
                                            '${state.quantity}',
                                            style: AppText.subtitle2,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            context.read<OrderBloc>().add(
                                                IncrementQuantityOrderEvent());
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              color: AppColors.lightGray,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thời Gian Thuê',
                            style: AppText.subtitle3,
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Bắt đầu',
                                style: AppText.body2,
                              ),
                              TextButton.icon(
                                onPressed: () async {
                                  context
                                      .read<OrderBloc>()
                                      .add(FromTimeUpdated(context));
                                },
                                label: Text(
                                  state.startTime == null
                                      ? 'Chọn thời gian'
                                      : DateFormat('dd-MM-yyyy HH:mm')
                                          .format(state.startTime!),
                                  style: AppText.subtitle3.copyWith(
                                    color: state.startTime == null
                                        ? AppColors.grey
                                        : AppColors.fontColor,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: state.startTime == null
                                      ? AppColors.grey
                                      : AppColors.fontColor,
                                ),
                                icon: const Icon(Icons.access_time_sharp),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Kết thúc',
                                style: AppText.body2,
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  context
                                      .read<OrderBloc>()
                                      .add(EndTimeUpdated(context, car.price));
                                },
                                label: Text(
                                  state.endTime == null
                                      ? 'Chọn thời gian'
                                      : DateFormat('dd-MM-yyyy HH:mm')
                                          .format(state.endTime!),
                                  style: AppText.subtitle3.copyWith(
                                    color: state.endTime == null
                                        ? AppColors.grey
                                        : AppColors.fontColor,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: state.endTime == null
                                      ? AppColors.grey
                                      : AppColors.fontColor,
                                ),
                                icon: const Icon(Icons.access_time_sharp),
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chi tiết giá',
                            style: AppText.subtitle3,
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tổng tiền xe',
                                style: AppText.body2,
                              ),
                              Text(
                                formattedAmountCar(state.price),
                                style: AppText.subtitle3,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Phí giao xe',
                                style: AppText.body2,
                              ),
                              Text(
                               formattedAmountCar(state.delivery),
                                style: AppText.subtitle3,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Voucher giảm giá',
                                style: AppText.body2,
                              ),
                              Text(
                                '0',
                                style: AppText.subtitle3,
                              ),
                            ],
                          ),
                          const Divider(
                            height: 32,
                            thickness: 2,
                            color: Color(0xffe0e3e7),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tổng thanh toán',
                                style: AppText.subtitle3,
                              ),
                              Text(
                                formattedAmountCar(
                                  state.totalAmount != 0
                                      ? state.totalAmount
                                      : 0,
                                ),
                                style: AppText.subtitle3,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 32),
                      color: const Color(0xffe0e3e7),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/shield.svg',
                            color: Color(0xff57636C),
                            width: 45,
                            height: 45,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Chinh phục mọi địa điểm, mỗi bước chân là một hành trình mới. Khám phá thế giới với ứng dụng thuê xe - Đưa bạn đến mọi nơi, mọi lúc!',
                              style: AppText.subtitle3
                                  .copyWith(color: AppColors.primary),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
