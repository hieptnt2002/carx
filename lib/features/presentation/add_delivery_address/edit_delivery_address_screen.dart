// ignore_for_file: curly_braces_in_flow_control_structures, deprecated_member_use

import 'package:carx/features/presentation/add_delivery_address/bloc/delivery_address_handler_bloc.dart';
import 'package:carx/features/presentation/add_delivery_address/bloc/delivery_address_handler_event.dart';
import 'package:carx/features/presentation/add_delivery_address/bloc/delivery_address_handler_state.dart';
import 'package:carx/features/model/delivery_address.dart';
import 'package:carx/features/reponsitories/auth/auth_reponsitory_impl.dart';
import 'package:carx/loading/loading.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditDeliveryAddressScreen extends StatefulWidget {
  const EditDeliveryAddressScreen({super.key});

  @override
  State<EditDeliveryAddressScreen> createState() =>
      _EditDeliveryAddressScreenState();
}

class _EditDeliveryAddressScreenState extends State<EditDeliveryAddressScreen> {
  late DeliveryAddressHandlerBloc _addressBloc;
  late DeliveryAddress deliveryAddress;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    deliveryAddress =
        ModalRoute.of(context)!.settings.arguments as DeliveryAddress;

    _addressBloc
      ..add(UpdateIdDeliveryAddressEvent(deliveryAddress.id))
      ..add(TypeAddressChangeEvent(deliveryAddress.type))
      ..add(DefaultAddressChangeEvent(deliveryAddress.isSelected == 1))
      ..add(PhoneNumberChangeEvent(deliveryAddress.phone))
      ..add(AddressChangeEvent(deliveryAddress.address))
      ..add(RecipientNameChangeEvent(deliveryAddress.recipientName));
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    _addressBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Địa Chỉ'),
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
                  content: Text('Đã lưu'),
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
              return SingleChildScrollView(
                child: Container(
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
                          initialValue: deliveryAddress.recipientName,
                          cursorColor: AppColors.primary,
                          decoration: const InputDecoration(
                            hintText: 'Nhập tên người nhận',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: AppColors.primary),
                          onChanged: (value) {
                            _addressBloc.add(RecipientNameChangeEvent(value));
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
                          initialValue: deliveryAddress.phone,
                          cursorColor: AppColors.primary,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: 'Nhập số điện thoại',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: AppColors.primary),
                          onChanged: (value) {
                            _addressBloc.add(PhoneNumberChangeEvent(value));
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
                          initialValue: deliveryAddress.address,
                          cursorColor: AppColors.primary,
                          decoration: const InputDecoration(
                            hintText: 'Nhập địa chỉ giao(nhận)',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: AppColors.primary),
                          onChanged: (value) {
                            _addressBloc.add(AddressChangeEvent(value));
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 24, 12, 6),
                            child: ElevatedButton(
                              onPressed: () {
                                _nameFocusNode.unfocus();
                                _phoneFocusNode.unfocus();
                                _addressFocusNode.unfocus();
                                _addressBloc
                                    .add(EditDeliveryAddressToServerEvent());
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 16, 0, 16)),
                              child: const Text(
                                'Lưu Địa Chỉ',
                                style: AppText.subtitle2,
                              ),
                            ),
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12, 6, 12, 6),
                            child: TextButton(
                              onPressed: () async {
                                _nameFocusNode.unfocus();
                                _phoneFocusNode.unfocus();
                                _addressFocusNode.unfocus();
                                bool isRemove =
                                    await showBottomSheetRemoveAddress();
                                if (isRemove)
                                  _addressBloc.add(
                                      DeleteDeliveryAddressToServerEvent());
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 16, 0, 16)),
                              child: Text(
                                'Xóa Địa Chỉ',
                                style: AppText.body1
                                    .copyWith(color: Colors.redAccent),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> showBottomSheetRemoveAddress() {
    return showModalBottomSheet(
      context: context,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      enableDrag: true,
      builder: (context) {
        return SizedBox(
          height: 180,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 24, 12, 24),
            child: Column(
              children: [
                const Text(
                  'Xóa Địa Chỉ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bạn có muốn xóa địa chỉ giao hàng này không?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            'Có',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text('Không'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) => value ?? false);
  }
}
