// ignore_for_file: use_build_context_synchronously

import 'package:carx/features/model/order_management.dart';

import 'package:carx/components/item_car_booking.dart';

import 'package:carx/features/reponsitories/order/order_reponsitory_impl.dart';

import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_routes.dart';

import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';

class DistributorManageOrders extends StatefulWidget {
  const DistributorManageOrders({super.key});

  @override
  State<DistributorManageOrders> createState() =>
      _DistributorManageOrdersState();
}

class _DistributorManageOrdersState extends State<DistributorManageOrders>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<OrderManagement> orderDetails = [];
  late Map<String, dynamic> arguments;
  int id = 0;
  final tabs = [
    'Chờ xác nhận',
    'Đang giao',
    'Đang thuê',
    'Đã hoàn thành',
    'Đã hủy'
  ];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabs.length);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    id = arguments['id'];
    int tab = arguments['tab'];
    _tabController.animateTo(tab);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn Đặt Xe'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.secondary,
          tabs: tabs
              .map(
                (tab) => Tab(
                  child: Text(
                    tab,
                    style: AppText.body1.copyWith(color: AppColors.white),
                  ),
                ),
              )
              .toList(),
          onTap: (value) {
            arguments['tab'] = value;
          },
        ),
      ),
      body: FutureBuilder(
        future: OrderReponsitoryImpl.response().fetchOrdersByDistributor(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            orderDetails = snapshot.data ?? [];

            return TabBarView(
              controller: _tabController,
              children: [
                TabItem(
                  orderDetails: orderDetails
                      .where((element) => element.order.status == tabs[0])
                      .toList(),
                  arguments: arguments,
                ),
                TabItem(
                  orderDetails: orderDetails
                      .where((element) => element.order.status == tabs[1])
                      .toList(),
                  arguments: arguments,
                ),
                TabItem(
                  orderDetails: orderDetails
                      .where((element) => element.order.status == tabs[2])
                      .toList(),
                  arguments: arguments,
                ),
                TabItem(
                  orderDetails: orderDetails
                      .where((element) => element.order.status == tabs[3])
                      .toList(),
                  arguments: arguments,
                ),
                TabItem(
                  orderDetails: orderDetails
                      .where((element) => element.order.status == tabs[4])
                      .toList(),
                  arguments: arguments,
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final List<OrderManagement> orderDetails;
  final Map<String, dynamic> arguments;
  const TabItem(
      {super.key, required this.orderDetails, required this.arguments});
  @override
  Widget build(BuildContext context) {
    if (orderDetails.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              final reload = await Navigator.pushNamed(
                context,
                Routes.routeManageOrderDetails,
                arguments: orderDetails[index],
              );
              if (reload is bool) {
                if (reload == true) {
                  Navigator.pushReplacementNamed(
                      context, Routes.routeManageOrders,
                      arguments: arguments);
                }
              }
            },
            child: CarItemBooking(
              orderManagement: orderDetails[index],
            ),
          );
        },
        itemCount: orderDetails.length,
        shrinkWrap: true,
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/car-not-found.png',
              width: 220,
              height: 110,
              fit: BoxFit.contain,
            ),
            const Text(
              'Trống!',
              style: AppText.bodySmall,
            ),
          ],
        ),
      );
    }
  }
}
