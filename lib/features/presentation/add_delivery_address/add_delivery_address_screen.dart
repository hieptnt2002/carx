// ignore_for_file: deprecated_member_use

import 'package:carx/features/presentation/add_delivery_address/bloc/delivery_address_handler_bloc.dart';
import 'package:carx/features/presentation/add_delivery_address/bloc/delivery_address_handler_state.dart';
import 'package:carx/features/reponsitories/auth/auth_reponsitory_impl.dart';
import 'package:carx/loading/loading.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/delivery_address_handler_event.dart';

class AddDeliveryAddressScreen extends StatefulWidget {
  const AddDeliveryAddressScreen({super.key});

  @override
  State<AddDeliveryAddressScreen> createState() =>
      _AddDeliveryAddressScreenState();
}

class _AddDeliveryAddressScreenState extends State<AddDeliveryAddressScreen> {
  late DeliveryAddressHandlerBloc _addressBloc;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  @override
  void initState() {
    _addressBloc =
        DeliveryAddressHandlerBloc(AuthReponsitoryImpl.reponsitory());
    super.initState();
  }

  @override
  void dispose() {
    _addressBloc.close();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Địa Chỉ Mới'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, false);
          return false;
        },
        child: BlocProvider(
          create: (context) => _addressBloc,
          child: BlocConsumer<DeliveryAddressHandlerBloc,
              DeliveryAddressHandlerState>(
            listener: (context, state) {
              if (state.status == DeliveryAddressHandlerStatus.loading) {
                Loading().show(context: context);
              } else if (state.status == DeliveryAddressHandlerStatus.success) {
                Loading().hide();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Đã thêm'),
                  backgroundColor: AppColors.colorSuccess,
                ));
                Navigator.pop(context, true);
              } else if (state.status == DeliveryAddressHandlerStatus.failure) {
                Loading().hide();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.textError)));
              }
            },
            builder: (context, state) {
              return Container(
                color: AppColors.whiteSmoke,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Text(
                        'Liên hệ',
                        style: AppText.bodyGrey,
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      color: Colors.white,
                      height: 54,
                      alignment: Alignment.center,
                      child: TextFormField(
                        focusNode: _nameFocusNode,
                        cursorColor: AppColors.primary,
                        decoration: const InputDecoration(
                          hintText: 'Nhập tên người nhận',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: AppColors.primary),
                        onChanged: (value) {
                          context
                              .read<DeliveryAddressHandlerBloc>()
                              .add(RecipientNameChangeEvent(value));
                        },
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      margin: const EdgeInsets.only(top: 2),
                      color: Colors.white,
                      height: 54,
                      alignment: Alignment.center,
                      child: TextFormField(
                        focusNode: _phoneFocusNode,
                        cursorColor: AppColors.primary,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Nhập số điện thoại',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: AppColors.primary),
                        onChanged: (value) {
                          context
                              .read<DeliveryAddressHandlerBloc>()
                              .add(PhoneNumberChangeEvent(value));
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 24, 12, 12),
                      child: Text(
                        'Địa chỉ nhận',
                        style: AppText.bodyGrey,
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      color: Colors.white,
                      height: 54,
                      alignment: Alignment.center,
                      child: TextFormField(
                        focusNode: _addressFocusNode,
                        cursorColor: AppColors.primary,
                        decoration: const InputDecoration(
                          hintText: 'Nhập địa chỉ giao(nhận)',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: AppColors.primary),
                        onChanged: (value) {
                          context
                              .read<DeliveryAddressHandlerBloc>()
                              .add(AddressChangeEvent(value));
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      color: Colors.white,
                      height: 54,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Loại địa chỉ',
                              style: AppText.bodyFontColor,
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  context
                                      .read<DeliveryAddressHandlerBloc>()
                                      .add(TypeAddressChangeEvent('Home'));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: state.typeAddress == 'Home'
                                          ? Border.all(
                                              width: 1,
                                              color: AppColors.secondary)
                                          : null,
                                      color: AppColors.lightGray),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  child: Text(
                                    'Home',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: state.typeAddress == 'Home'
                                          ? AppColors.secondary
                                          : AppColors.primary,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () {
                                  context
                                      .read<DeliveryAddressHandlerBloc>()
                                      .add(TypeAddressChangeEvent('Work'));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: state.typeAddress == 'Work'
                                          ? Border.all(
                                              width: 1,
                                              color: AppColors.secondary)
                                          : null,
                                      color: AppColors.lightGray),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  child: Text(
                                    'Work',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: state.typeAddress == 'Work'
                                          ? AppColors.secondary
                                          : AppColors.primary,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      color: Colors.white,
                      height: 54,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Đặt địa chỉ mặc định',
                            style: AppText.bodyFontColor,
                          ),
                          Switch(
                            value: state.isDefault,
                            onChanged: (value) {
                              context
                                  .read<DeliveryAddressHandlerBloc>()
                                  .add(DefaultAddressChangeEvent(value));
                            },
                            activeColor: AppColors.secondary,
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            onPressed: () {
                              _nameFocusNode.unfocus();
                              _phoneFocusNode.unfocus();
                              _addressFocusNode.unfocus();
                              context
                                  .read<DeliveryAddressHandlerBloc>()
                                  .add(AddAddressToServerEvent());
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 16, 0, 16)),
                            child: const Text(
                              'Thêm Địa Chỉ',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
