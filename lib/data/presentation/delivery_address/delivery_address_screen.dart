// ignore_for_file: use_build_context_synchronously


import 'package:carx/data/presentation/delivery_address/bloc/delivery_address_state.dart';
import 'package:carx/data/model/delivery_address.dart';
import 'package:carx/data/reponsitories/auth/auth_reponsitory_impl.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_routes.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'bloc/delivery_address_bloc.dart';
import 'bloc/delivery_address_event.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Địa Chỉ Của Bạn',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            DeliveryAddressBloc(AuthReponsitoryImpl.reponsitory())
              ..add(FetchDeliveryAddressesEvent()),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () async {
                          bool isAdd = await Navigator.pushNamed(
                            context,
                            Routes.routeAddDeliveryAddresses,
                          ) as bool;
                          if (isAdd) {
                            Navigator.pushReplacementNamed(
                                context, Routes.routeDeliveryAddresses);
                          }
                        },
                        icon: const Icon(
                          Icons.add_circle_outline_sharp,
                          color: AppColors.secondary,
                        ),
                        label: const Text(
                          'Thêm Địa Chỉ Mới',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w500),
                        ),
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            foregroundColor: AppColors.fontColor,
                            shadowColor: Colors.transparent),
                      ),
                    ),
                  ],
                ),
                BlocBuilder<DeliveryAddressBloc, DeliveryAddressState>(
                  builder: (context, state) {
                    if (state.status == DeliveryAddressesStatus.loading) {
                      return const SpinKitCircle(
                        color: AppColors.primary,
                        size: 70,
                      );
                    } else  if (state.status == DeliveryAddressesStatus.success) {
                      return ListView.builder(
                        itemBuilder: (context, index) =>
                            itemAddress(state.deliveryAddresses[index]),
                        itemCount: state.deliveryAddresses.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemAddress(DeliveryAddress deliveryAddress) {
    return GestureDetector(
      onTap: () async {
        bool isEdit = await Navigator.pushNamed(
            context, Routes.routeEditDeliveryAddresses,
            arguments: deliveryAddress) as bool;
        if (isEdit) {
          Navigator.pushReplacementNamed(
              context, Routes.routeDeliveryAddresses);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.whiteSmoke,
          border: Border.all(color: AppColors.lightGray, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          deliveryAddress.recipientName ?? 'Default',
                          style: AppText.bodyFontColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          deliveryAddress.address ?? 'Default',
                          style: AppText.bodyFontColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(text: 'Mobile: '),
                              TextSpan(text: deliveryAddress.phone ?? 'Default')
                            ],
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.fontColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors.lightGray),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      deliveryAddress.type ?? 'Default',
                      style: AppText.bodyFontColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            ),
            Visibility(
              visible: deliveryAddress.isSelected == 1,
              child: const Text(
                'Default',
                style: AppText.body1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
