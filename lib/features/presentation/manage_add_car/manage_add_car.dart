import 'dart:io';

import 'package:carx/features/presentation/manage_add_car/bloc/add_car_bloc.dart';
import 'package:carx/features/presentation/manage_add_car/bloc/add_car_event.dart';
import 'package:carx/features/presentation/manage_add_car/bloc/add_car_state.dart';
import 'package:carx/features/reponsitories/car/car_reponsitory_impl.dart';
import 'package:carx/loading/box_loading.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageAddCar extends StatefulWidget {
  const ManageAddCar({super.key});

  @override
  State<ManageAddCar> createState() => _ManageAddCarState();
}

class _ManageAddCarState extends State<ManageAddCar> {
  late AddCarBloc _addCarBloc;

  @override
  void didChangeDependencies() {
    int id = ModalRoute.of(context)!.settings.arguments as int;
    _addCarBloc = AddCarBloc(CarReponsitoryImpl.response());
    _addCarBloc.add(GetDistributorIdEvent(id));
    _addCarBloc.add(FetchListBrandEvent());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addCarBloc,
      child: BlocConsumer<AddCarBloc, AddCarState>(
        listener: (context, state) {
          if (state.statusAddCar == AddCarStatus.loading) {
            BoxLoading().show(context: context);
          } else if (state.statusAddCar == AddCarStatus.success) {
            BoxLoading().hide();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Đã thêm xe vào cửa hàng.',
                style: AppText.bodyDefault.copyWith(color: Colors.green),
              ),
              backgroundColor: Colors.black54,
            ));
          } else if (state.statusAddCar == AddCarStatus.failure) {
            BoxLoading().hide();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                state.textError,
                style: AppText.bodyDefault.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.black54,
            ));
          }
        },
        builder: (context, state) {
          List<File> imageFiles = state.imageFiles;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Thêm Xe Mới'),
            ),
            backgroundColor: AppColors.white,
            bottomNavigationBar: Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ElevatedButton(
                onPressed: () {
                  _addCarBloc.add(AddCarToServerEvent());
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12)),
                child: Text(
                  'Lưu',
                  style: AppText.subtitle1.copyWith(color: AppColors.white),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      mainAxisExtent:
                          MediaQuery.of(context).size.width / 4 - 8.0,
                    ),
                    padding: const EdgeInsets.all(16),
                    itemCount:
                        imageFiles.length < 4 ? imageFiles.length + 1 : 4,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == imageFiles.length && imageFiles.length < 4) {
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isDismissible: true,
                              showDragHandle: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24)),
                              ),
                              enableDrag: true,
                              builder: (context) {
                                return SizedBox(
                                  height: 163,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Tùy chọn hình ảnh',
                                        style: AppText.title1
                                            .copyWith(color: AppColors.primary),
                                      ),
                                      const SizedBox(height: 16),
                                      ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: AppColors.lightGray,
                                          child: Icon(
                                            Icons.photo_camera,
                                            color: Colors.black,
                                          ),
                                        ),
                                        title: Text(
                                          'Chụp ảnh',
                                          style: AppText.subtitle1.copyWith(
                                              color: AppColors.primary),
                                        ),
                                        onTap: () {
                                          _addCarBloc.add(
                                              CaptureImageFromCameraEvent());
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: AppColors.lightGray,
                                          child: Icon(
                                            Icons.add_photo_alternate_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                        title: Text(
                                          'Chọn ảnh từ thư viện',
                                          style: AppText.subtitle1.copyWith(
                                              color: AppColors.primary),
                                        ),
                                        onTap: () {
                                          _addCarBloc
                                              .add(PickImageFromGalleryEvent());
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: AppColors.whiteSmoke),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 36,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: Image.file(
                            imageFiles[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  Visibility(
                    visible: imageFiles.isEmpty,
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      height: 40,
                      color: Colors.red.withAlpha(30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Vui lòng đăng tải tối thiểu 1 hình ảnh về xe này.',
                          style: AppText.bodySmall
                              .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 6),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Tên xe',
                            style: AppText.bodyDefault,
                          ),
                          TextSpan(
                            text: '*',
                            style:
                                AppText.bodyDefault.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      _addCarBloc.add(ChangeNameCarEvent(value));
                    },
                    autocorrect: false,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tên xe',
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.lightGray, width: 1),
                      ),
                      fillColor: AppColors.white,
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400),
                      filled: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.lightGray, width: 1),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: AppText.bodyDefault,
                    maxLines: 1,
                  ),
                  Visibility(
                    visible: state.nameCar.isNotEmpty,
                    child: const Divider(
                      height: 12,
                      thickness: 12,
                      color: AppColors.whiteSmoke,
                    ),
                  ),
                  Visibility(
                    visible: state.nameCar.isEmpty,
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      height: 40,
                      color: Colors.red.withAlpha(30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Vui lòng nhập Tên xe.',
                            style: AppText.bodySmall
                                .copyWith(color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 6),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Mô tả về xe',
                            style: AppText.bodyDefault,
                          ),
                          TextSpan(
                            text: '*',
                            style:
                                AppText.bodyDefault.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      _addCarBloc.add(ChangeDescriptionsCarEvent(value));
                    },
                    autocorrect: false,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      hintText: 'Nhập mô tả xe',
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.lightGray, width: 1),
                      ),
                      fillColor: AppColors.white,
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400),
                      filled: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.lightGray, width: 1),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: AppText.bodyDefault,
                    maxLines: 5,
                  ),
                  Visibility(
                    visible: state.descriptions.isNotEmpty,
                    child: const Divider(
                      height: 12,
                      thickness: 12,
                      color: AppColors.whiteSmoke,
                    ),
                  ),
                  Visibility(
                    visible: state.descriptions.isEmpty,
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      height: 40,
                      color: Colors.red.withAlpha(30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Vui lòng nhập Mô tả xe.',
                          style: AppText.bodySmall
                              .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.apps,
                              color: AppColors.fontColor,
                            ),
                            const SizedBox(width: 6),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Thương hiệu',
                                    style: AppText.bodyDefault,
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: AppText.bodyDefault
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: DropdownMenu<String>(
                              dropdownMenuEntries: state.brands.map((brand) {
                                return DropdownMenuEntry<String>(
                                  value: '${brand.id}',
                                  label: brand.name,
                                );
                              }).toList(),
                              hintText: 'Chọn hãng xe',
                              inputDecorationTheme: const InputDecorationTheme(
                                  border: InputBorder.none),
                              onSelected: (value) {
                                _addCarBloc.add(ChangeBrandCarEvent(value));
                              },
                              width: 150,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: AppColors.whiteSmoke,
                  ),
                  Visibility(
                    visible: state.brandId.isEmpty,
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      height: 40,
                      color: Colors.red.withAlpha(30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Vui lòng chọn Thương hiệu xe.',
                          style: AppText.bodySmall
                              .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.price_change,
                              color: AppColors.fontColor,
                            ),
                            const SizedBox(width: 6),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Giá',
                                    style: AppText.bodyDefault,
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: AppText.bodyDefault
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              _addCarBloc.add(ChangePriceCarEvent(value));
                            },
                            autocorrect: false,
                            cursorColor: Colors.black,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              hintText: 'Nhập',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                              fillColor: AppColors.white,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w400),
                              filled: true,
                              suffix: Text('đ'),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: AppText.body1,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: AppColors.whiteSmoke,
                  ),
                  Visibility(
                    visible: state.price.isEmpty,
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      height: 40,
                      color: Colors.red.withAlpha(30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Vui lòng nhập Giá thuê xe.',
                          style: AppText.bodySmall
                              .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome_motion,
                              color: AppColors.fontColor,
                            ),
                            const SizedBox(width: 6),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Số lượng xe có sẵn',
                                    style: AppText.bodyDefault,
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: AppText.bodyDefault
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              _addCarBloc.add(ChangeQuantityCarEvent(value));
                            },
                            autocorrect: false,
                            cursorColor: Colors.black,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              hintText: 'Nhập',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                              fillColor: AppColors.white,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w400),
                              filled: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: AppText.body1,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: AppColors.whiteSmoke,
                  ),
                  Visibility(
                    visible: state.quantity.isEmpty,
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      height: 40,
                      color: Colors.red.withAlpha(30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Vui lòng nhập Số lượng xe đang có.',
                          style: AppText.bodySmall
                              .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.chair,
                              color: AppColors.fontColor,
                            ),
                            const SizedBox(width: 6),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Chỗ ngồi',
                                    style: AppText.bodyDefault,
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: AppText.bodyDefault
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              _addCarBloc.add(ChangeSeatsCarEvent(value));
                            },
                            autocorrect: false,
                            cursorColor: Colors.black,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              hintText: 'Nhập',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                              fillColor: AppColors.white,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w400),
                              filled: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: AppText.body1,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: AppColors.whiteSmoke,
                  ),
                  Visibility(
                    visible: state.seats.isEmpty,
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      height: 40,
                      color: Colors.red.withAlpha(30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Vui lòng nhập Số lượng xe đang có.',
                          style: AppText.bodySmall
                              .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.speed,
                              color: AppColors.fontColor,
                            ),
                            const SizedBox(width: 6),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Tốc độ tối đa',
                                    style: AppText.bodyDefault,
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: AppText.bodyDefault
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              _addCarBloc.add(ChangeTopSpeedCarEvent(value));
                            },
                            autocorrect: false,
                            cursorColor: Colors.black,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              hintText: 'Nhập',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                              fillColor: AppColors.white,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w400),
                              filled: true,
                              suffix: Text('km/h'),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: AppText.body1,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: AppColors.whiteSmoke,
                  ),
                  Visibility(
                    visible: state.topSpeed.isEmpty,
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      height: 40,
                      color: Colors.red.withAlpha(30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Vui lòng nhập Tốc độ tối đa của xe.',
                          style: AppText.bodySmall
                              .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.gas_meter_rounded,
                              color: AppColors.fontColor,
                            ),
                            const SizedBox(width: 6),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Động cơ',
                                    style: AppText.bodyDefault,
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: AppText.bodyDefault
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              _addCarBloc.add(ChangeEngineCarEvent(value));
                            },
                            autocorrect: false,
                            cursorColor: Colors.black,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              hintText: 'Nhập',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                              fillColor: AppColors.white,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w400),
                              filled: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: AppText.body1,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: AppColors.whiteSmoke,
                  ),
                  Visibility(
                    visible: state.engine.isEmpty,
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      height: 40,
                      color: Colors.red.withAlpha(30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Vui lòng nhập Động cơ xe.',
                          style: AppText.bodySmall
                              .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.dynamic_form_outlined,
                              color: AppColors.fontColor,
                            ),
                            const SizedBox(width: 6),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Mã lực',
                                    style: AppText.bodyDefault,
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: AppText.bodyDefault
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              _addCarBloc.add(ChangeHorsePowerCarEvent(value));
                            },
                            autocorrect: false,
                            cursorColor: Colors.black,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              hintText: 'Nhập',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                              fillColor: AppColors.white,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w400),
                              filled: true,
                              suffix: Text('hp'),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.lightGray, width: 1),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: AppText.body1,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: AppColors.whiteSmoke,
                  ),
                  Visibility(
                    visible: state.horsePower.isEmpty,
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      height: 40,
                      color: Colors.red.withAlpha(30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Vui lòng nhập Mã lực xe.',
                          style: AppText.bodySmall
                              .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
