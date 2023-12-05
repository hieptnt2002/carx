// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/data/presentation/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:carx/data/presentation/edit_profile/bloc/edit_profile_event.dart';
import 'package:carx/data/presentation/edit_profile/bloc/edit_profile_state.dart';
import 'package:carx/data/reponsitories/auth/auth_reponsitory_impl.dart';
import 'package:carx/loading/loading.dart';

import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';

import 'package:carx/utilities/dialog/save_profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  late EditProfileBloc profileBloc;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  @override
  void initState() {
    profileBloc = EditProfileBloc(AuthReponsitoryImpl.reponsitory());
    profileBloc.add(FetchUserEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    profileBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chỉnh Sửa Thông Tin',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => profileBloc,
        child: BlocConsumer<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state.status == SaveProfileStatus.loading) {
              Loading().show(context: context);
            } else if (state.status == SaveProfileStatus.success) {
              Loading().hide();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  'Đã lưu',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.colorSuccess,
              ));
            } else {
              Loading().hide();
            }
          },
          builder: (context, state) {
            if (state.userStatus == FetchUserStatus.success) {
              return WillPopScope(
                onWillPop: () async {
                  Navigator.pop(context, true);
                  return false;
                },
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl:
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDxEtq18osjks2ukF7EIrK6Eez6I4aqqbf6w&usqp=CAU',
                          width: width,
                          height: height / 4,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0, height / 7, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: Stack(
                                  children: [
                                    BlocBuilder<EditProfileBloc,
                                        EditProfileState>(
                                      builder: (context, state) {
                                        if (state.imageFile != null) {
                                          return ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(9999)),
                                            child: Image.file(
                                              state.imageFile!,
                                              width: 109,
                                              height: 109,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        } else {
                                          return ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(9999)),
                                            child: CachedNetworkImage(
                                              imageUrl: state.imageUrl!,
                                              width: 109,
                                              height: 109,
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) {
                                                return Image.asset(
                                                  'assets/images/logo-dark.png',
                                                  width: 109,
                                                  height: 109,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            showDragHandle: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(24),
                                                  topRight:
                                                      Radius.circular(24)),
                                            ),
                                            enableDrag: true,
                                            builder: (context) {
                                              return SizedBox(
                                                height: 163,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Chọn tùy chọn hình ảnh',
                                                      style: AppText.title1
                                                          .copyWith(
                                                              color: AppColors
                                                                  .primary),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    ListTile(
                                                      leading:
                                                          const CircleAvatar(
                                                        backgroundColor:
                                                            AppColors.lightGray,
                                                        child: Icon(
                                                          Icons.photo_camera,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      title: Text(
                                                        'Chụp ảnh',
                                                        style: AppText.subtitle1
                                                            .copyWith(
                                                                color: AppColors
                                                                    .primary),
                                                      ),
                                                      onTap: () {
                                                        profileBloc.add(
                                                            CaptureImageFromCameraEvent());
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading:
                                                          const CircleAvatar(
                                                        backgroundColor:
                                                            AppColors.lightGray,
                                                        child: Icon(
                                                          Icons
                                                              .add_photo_alternate_outlined,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      title: Text(
                                                        'Chọn ảnh từ thư viện',
                                                        style: AppText.subtitle1
                                                            .copyWith(
                                                                color: AppColors
                                                                    .primary),
                                                      ),
                                                      onTap: () {
                                                        profileBloc.add(
                                                            PickImageFromGalleryEvent());
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
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(999))),
                                          child: const Icon(
                                            Icons.photo_camera,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.defaultName ?? 'Unknown',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppText.header
                                            .copyWith(color: AppColors.primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.email ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppText.subtitle3
                                            .copyWith(color: AppColors.primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              TextFormField(
                                focusNode: _nameFocusNode,
                                cursorColor: AppColors.primary,
                                initialValue: state.name,
                                decoration: InputDecoration(
                                  hintText: 'Tên người dùng',
                                  prefixIcon: const Icon(Icons.person),
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary, width: 1),
                                  ),
                                  prefixIconColor: AppColors.primary,
                                ),
                                style:
                                    const TextStyle(color: AppColors.primary),
                                onChanged: (value) {
                                  profileBloc
                                      .add(UserNameEditEvent(name: value));
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                focusNode: _addressFocusNode,
                                initialValue: state.address,
                                cursorColor: AppColors.primary,
                                decoration: InputDecoration(
                                  hintText: 'Địa chỉ',
                                  prefixIcon:
                                      const Icon(Icons.location_city_outlined),
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary, width: 1),
                                  ),
                                  prefixIconColor: AppColors.primary,
                                ),
                                style:
                                    const TextStyle(color: AppColors.primary),
                                onChanged: (value) {
                                  profileBloc
                                      .add(AddressEditEvent(address: value));
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                focusNode: _phoneFocusNode,
                                initialValue: state.phone,
                                cursorColor: AppColors.primary,
                                decoration: InputDecoration(
                                  hintText: 'Số điện thoại',
                                  prefixIcon:
                                      const Icon(Icons.phone_android_rounded),
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary, width: 1),
                                  ),
                                  prefixIconColor: AppColors.primary,
                                ),
                                style:
                                    const TextStyle(color: AppColors.primary),
                                onChanged: (value) {
                                  profileBloc.add(PhoneEditEvent(phone: value));
                                },
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.only(left: 12),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/gender.svg',
                                          width: 24,
                                          height: 24,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Giới tính',
                                          style: AppText.subtitle1.copyWith(
                                              color: AppColors.primary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RadioListTile(
                                            title: const Text(
                                              'Nam',
                                              style: TextStyle(
                                                  color: AppColors.primary),
                                            ),
                                            value: 'Male',
                                            groupValue: state.gender,
                                            contentPadding: EdgeInsets.zero,
                                            visualDensity: const VisualDensity(
                                              vertical:
                                                  VisualDensity.minimumDensity,
                                              horizontal:
                                                  VisualDensity.minimumDensity,
                                            ),
                                            activeColor: AppColors.primary,
                                            onChanged: (value) {
                                              profileBloc.add(
                                                  GenderSelectionEvent(
                                                      gender: value));
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                            title: const Text(
                                              'Nữ',
                                              style: TextStyle(
                                                  color: AppColors.primary),
                                            ),
                                            value: 'FeMale',
                                            groupValue: state.gender,
                                            contentPadding: EdgeInsets.zero,
                                            visualDensity: const VisualDensity(
                                              vertical:
                                                  VisualDensity.minimumDensity,
                                              horizontal:
                                                  VisualDensity.minimumDensity,
                                            ),
                                            activeColor: AppColors.primary,
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            onChanged: (value) {
                                              profileBloc.add(
                                                  GenderSelectionEvent(
                                                      gender: value));
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                            title: const Text(
                                              'Khác',
                                              style: TextStyle(
                                                  color: AppColors.primary),
                                            ),
                                            value: 'Other',
                                            groupValue: state.gender,
                                            contentPadding: EdgeInsets.zero,
                                            visualDensity: const VisualDensity(
                                              vertical:
                                                  VisualDensity.minimumDensity,
                                              horizontal:
                                                  VisualDensity.minimumDensity,
                                            ),
                                            activeColor: AppColors.primary,
                                            onChanged: (value) {
                                              profileBloc.add(
                                                  GenderSelectionEvent(
                                                      gender: value));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(16, 32, 16, 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          _nameFocusNode.unfocus();
                                          _phoneFocusNode.unfocus();
                                          _addressFocusNode.unfocus();
                                          bool isSave =
                                              await showSaveProfileDialog(
                                            context: context,
                                            title: 'Lưu thông tin',
                                            content:
                                                'Bạn có muốn lưu thông tin của mình sau khi chỉnh sửa?',
                                          );
                                          if (isSave) {
                                            profileBloc
                                                .add(SaveUserInfomationEvent());
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                        child: Text(
                                          'Lưu',
                                          style: AppText.title1.copyWith(
                                              color: AppColors.secondary),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return _shimmerLoadingProfile();
            }
          },
        ),
      ),
    );
  }

  Widget _shimmerLoadingProfile() {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SpinKitCircle(
          color: Colors.grey,
          size: 70,
        ),
      ),
    );
  }
}
