// ignore_for_file: use_build_context_synchronously

import 'package:carx/data/presentation/delivery_address/bloc/delivery_address_bloc.dart';
import 'package:carx/data/presentation/delivery_address/bloc/delivery_address_event.dart';
import 'package:carx/data/presentation/delivery_address/bloc/delivery_address_state.dart';
import 'package:carx/data/model/delivery_address.dart';

import 'package:carx/data/reponsitories/auth/auth_reponsitory_impl.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_routes.dart';
import 'package:carx/utilities/app_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget selectAddressWidget(
    BuildContext context, DeliveryAddress? currentAddress) {
  DeliveryAddress? resultDeliveryAddress;
  return WillPopScope(
    onWillPop: () async {
      Navigator.pop(context, resultDeliveryAddress);
      return false;
    },
    child: BlocProvider(
      create: (context) => DeliveryAddressBloc(
          AuthReponsitoryImpl.reponsitory())
        ..add(FetchDeliveryAddressesEvent())
        ..add(DeliveryAddressSelectionEvent(deliveryAddress: currentAddress)),
      child: BlocBuilder<DeliveryAddressBloc, DeliveryAddressState>(
        builder: (context, state) {
          if (state.status == DeliveryAddressesStatus.loading) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chọn Địa Chỉ Nhận Xe',
                        style: AppText.subtitle3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          Navigator.pop(context, resultDeliveryAddress);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: AppColors.lightGray,
                  thickness: 2,
                  height: 12,
                ),
              ],
            );
          } else if (state.status == DeliveryAddressesStatus.success) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                         'Chọn Địa Chỉ Nhận Xe',
                        style: AppText.subtitle3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context, resultDeliveryAddress);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: AppColors.lightGray,
                  thickness: 2,
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'LƯU ĐỊA CHỈ',
                        style: AppText.bodyFontColor,
                      ),
                      TextButton.icon(
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
                          'Thêm địa chỉ mới',
                          style: AppText.body1,
                        ),
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            foregroundColor: AppColors.fontColor,
                            shadowColor: Colors.transparent),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2 - 72,
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final deliveryAddress = state.deliveryAddresses[index];
                      return GestureDetector(
                        onTap: () {
                          context.read<DeliveryAddressBloc>().add(
                              DeliveryAddressSelectionEvent(
                                  deliveryAddress: deliveryAddress));
                          resultDeliveryAddress = deliveryAddress;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.whiteSmoke,
                            border: Border.all(
                                color: AppColors.lightGray, width: 1),
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
                                            deliveryAddress.recipientName ??
                                                'Default',
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
                                            '${deliveryAddress.address}',
                                            style: AppText.bodyFontColor
                                                .copyWith(
                                                    color: AppColors.primary),
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
                                                const TextSpan(
                                                    text: 'Mobile: '),
                                                TextSpan(
                                                    text:
                                                        deliveryAddress.phone ??
                                                            'Default')
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
                                    const SizedBox(width: 6),
                                  ],
                                ),
                              ),
                              Radio(
                                value: deliveryAddress,
                                groupValue: state.deliveryAddressSelected,
                                onChanged: (value) {
                                  context.read<DeliveryAddressBloc>().add(
                                      DeliveryAddressSelectionEvent(
                                          deliveryAddress: deliveryAddress));
                                  resultDeliveryAddress = deliveryAddress;
                                },
                                activeColor: AppColors.secondary,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: state.deliveryAddresses.length,
                    scrollDirection: Axis.vertical,
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    ),
  );
}
