// ignore_for_file: avoid_print

import 'package:carx/features/model/order.dart';
import 'package:carx/features/presentation/payment/bloc/payment_bloc.dart';
import 'package:carx/features/presentation/payment/bloc/payment_event.dart';
import 'package:carx/features/presentation/payment/bloc/payment_state.dart';
import 'package:carx/features/reponsitories/order/order_reponsitory_impl.dart';

import 'package:carx/features/presentation/order_success/slide_bottom_route.dart';

import 'package:carx/features/presentation/order_success/order_success_view.dart';
import 'package:carx/loading/loading.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:carx/utilities/util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentSreen extends StatefulWidget {
  const PaymentSreen({super.key});

  @override
  State<PaymentSreen> createState() => _PaymentSreenState();
}

class _PaymentSreenState extends State<PaymentSreen> {
  @override
  Widget build(BuildContext context) {
    final mapOrder =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Order order = mapOrder['order'];

    return BlocProvider(
      create: (context) => PaymentBloc(OrderReponsitoryImpl.response())
        ..add(OrderCarUpdate(order: order)),
      child: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state.status == PaymentStatus.loading) {
            Loading().show(context: context);
          } else if (state.status == PaymentStatus.failure) {
            Loading().hide();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorText)));
          } else if (state.status == PaymentStatus.success) {
            Loading().hide();
            Navigator.of(context).pushAndRemoveUntil(
              SlideBottomRoute(page: const OrderSucess(), arguments: mapOrder),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Thanh toán'),
            ),
            bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x1A000000),
                    offset: Offset(0, -2),
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
                        formattedAmountCar(order.totalAmount!),
                        style: AppText.title2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '0% off',
                        style: AppText.title2
                            .copyWith(color: AppColors.colorSuccess),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<PaymentBloc>().add(PaymentButtonSelectEvent(
                          paymentMethod: state.selectedPaymentMethod));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      fixedSize: const Size(130, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      side: const BorderSide(
                          width: 1, color: AppColors.lightGray),
                    ),
                    child: Text(
                      'Thanh toán',
                      style: AppText.subtitle2.copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('THẺ ĐÃ LƯU'),
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 64,
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xffe0e3e7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              banks[index][2],
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        minVerticalPadding: 0,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              banks[index][0],
                              style: AppText.subtitle3,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              banks[index][1],
                              overflow: TextOverflow.ellipsis,
                              style: AppText.body2,
                            ),
                          ],
                        ),
                        onTap: () {
                          context.read<PaymentBloc>().add(
                              SelectionPaymentMethodEvent(
                                  itemSelected: banks[index][0]));
                        },
                        trailing: Radio(
                          value: banks[index][0],
                          groupValue: state.selectedPaymentMethod,
                          onChanged: (value) {
                            context.read<PaymentBloc>().add(
                                SelectionPaymentMethodEvent(
                                    itemSelected: banks[index][0]));
                          },
                        ),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: banks.length,
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('VÍ'),
                  ),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 48,
                      ),
                      itemBuilder: (context, index) {
                        return imageWallet(
                          context: context,
                          assetImage: wallets[index][1],
                          currentItem: state.selectedPaymentMethod,
                          item: wallets[index][0],
                        );
                      },
                      itemCount: wallets.length,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 64,
                    child: ListTile(
                      onTap: () {
                        context.read<PaymentBloc>().add(
                            SelectionPaymentMethodEvent(
                                itemSelected: 'Cash on delivery'));
                      },
                      minVerticalPadding: 0,
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xffe0e3e7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            'assets/svg/cube.svg',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Thanh toán khi nhận xe',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Thanh toán ngay sau khi nhận được xe',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: Radio(
                        value: 'Cash on delivery',
                        groupValue: state.selectedPaymentMethod,
                        onChanged: (value) {
                          context.read<PaymentBloc>().add(
                              SelectionPaymentMethodEvent(
                                  itemSelected: 'Cash on delivery'));
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xffe0e3e7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.wallet_giftcard_rounded),
                      title: const Text(
                        'Áp dụng mã khuyến mãi',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CHI TIẾT GIÁ',
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
                              formattedAmountCar(order.totalAmount!),
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
                              '${order.deliveryCharges}',
                              style: AppText.subtitle3
                                  .copyWith(color: AppColors.colorSuccess),
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
                              formattedAmountCar(order.totalAmount!),
                              style: AppText.subtitle3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget imageWallet({
    required BuildContext context,
    required String item,
    required String assetImage,
    required String currentItem,
  }) {
    return InkWell(
      onTap: () {
        context
            .read<PaymentBloc>()
            .add(SelectionPaymentMethodEvent(itemSelected: item));
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xffe0e3e7),
          borderRadius: BorderRadius.circular(12),
          border: currentItem == item
              ? Border.all(width: 1, color: Colors.blue)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            assetImage,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

const List<dynamic> banks = [
  [
    'Bank Of America',
    'XXXX XXXX XXXX 7891',
    'assets/images/Bank-of-America.png'
  ],
  [
    'China Construction Bank',
    'XXXX XXXX XXXX 6933',
    'assets/images/China-Construction-Bank.png'
  ],
  [
    'JPMorgan Chase',
    'XXXX XXXX XXXX 5555',
    'assets/images/JP-Morgan-Chase-Symbol.png'
  ],
];

const List<dynamic> wallets = [
  ['BitKeep Wallet', 'assets/images/BitKeep-Wallet.png'],
  ['CoinbaseWallet', 'assets/images/Coinbase-Wallet.png'],
  ['ElectrumWallet', 'assets/images/Electrum-Wallet.png'],
  ['MetaMask Wallet', 'assets/images/MetaMask-Wallet.png'],
  ['PayPal Wallet', 'assets/images/paypal-wallet.png'],
  ['TrustWallet', 'assets/images/TrustWallet.png'],
];
