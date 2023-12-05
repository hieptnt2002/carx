// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/utilities/app_text.dart';

import 'package:carx/data/presentation/personal/bloc/personal_bloc.dart';
import 'package:carx/data/presentation/personal/bloc/personal_event.dart';
import 'package:carx/data/presentation/personal/bloc/personal_state.dart';
import 'package:carx/data/reponsitories/auth/auth_reponsitory_impl.dart';
import 'package:carx/service/auth/firebase_auth_provider.dart';
import 'package:carx/utilities/app_colors.dart';

import 'package:carx/utilities/app_routes.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class PersonalView extends StatefulWidget {
  const PersonalView({super.key});

  @override
  State<PersonalView> createState() => _PersonalViewState();
}

class _PersonalViewState extends State<PersonalView> {
  late PersonalBloc _personalBloc;
  @override
  void initState() {
    _personalBloc = PersonalBloc(
      AuthReponsitoryImpl.reponsitory(),
      FirebaseAuthProvider(),
    );
    _personalBloc.add(FetchUserEvent());
    super.initState();
  }

  @override
  void dispose() {
    _personalBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _personalBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cá nhân',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 0,
                    child: Text('Chỉnh sửa hồ sơ'),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Đăng xuất'),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 0) {
                  final isChange = await Navigator.of(context)
                      .pushNamed(Routes.routeEditProfile);
                  if (isChange is bool) {
                    if (isChange == true) {
                      Navigator.pushReplacementNamed(context, Routes.routeMain);
                    }
                  }
                } else if (value == 1) {
                  _personalBloc.add(LogoutEvent());
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.routeLogin,
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
        body: BlocBuilder<PersonalBloc, PersonalState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () async {
                        final isChange = await Navigator.of(context)
                            .pushNamed(Routes.routeEditProfile);
                        if (isChange is bool) {
                          if (isChange == true) {
                            Navigator.pushReplacementNamed(
                                context, Routes.routeMain);
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(1.0),
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(9999)),
                              border: Border.all(
                                  width: 1, color: const Color(0xffe0e3e7)),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(9999)),
                              child: BlocBuilder<PersonalBloc, PersonalState>(
                                bloc: _personalBloc,
                                builder: (context, state) {
                                  if (state.fetchUserStatus ==
                                      FetchUserStatus.loading) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey.withOpacity(0.5),
                                      highlightColor: Colors.grey,
                                      child: Image.asset(
                                        'assets/images/logo-dark.png',
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } else if (state.fetchUserStatus ==
                                      FetchUserStatus.success) {
                                    return CachedNetworkImage(
                                      imageUrl: '${state.user?.image}',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                          'assets/images/logo-dark.png',
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    );
                                  } else {
                                    if (state.fetchUserStatus ==
                                        FetchUserStatus.failure) {
                                      return Image.asset(
                                        'assets/images/logo-dark.png',
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(999))),
                              child: const Icon(
                                Icons.photo_camera,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      state.user?.name ?? 'XCar',
                      style: AppText.title1.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final SettingItem item = items[index];
                      return Container(
                        margin:
                            const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
                        child: GestureDetector(
                          onTap: () async {
                            final isChange = await Navigator.of(context)
                                .pushNamed(item.route);
                            if (isChange is bool) {
                              if (isChange == true) {
                                Navigator.pushReplacementNamed(
                                    context, Routes.routeMain);
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              border: Border.all(
                                  width: 1, color: AppColors.lightGray),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.lightGray,
                                child: SvgPicture.asset(
                                  item.icon,
                                  color: AppColors.primary,
                                  width: 24,
                                ),
                              ),
                              title: Text(item.title),
                              subtitle: Text(item.subtitle),
                              trailing: const Icon(
                                  Icons.keyboard_arrow_right_rounded),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<PersonalBloc, PersonalState>(
                    bloc: _personalBloc,
                    builder: (context, state) {
                      if (state.fetchUserStatus == FetchUserStatus.success &&
                          state.distributor != null) {
                        return GestureDetector(
                          onTap: () {
                           Navigator.pushNamed(context, Routes.routeManageDistributor,arguments: state.distributor);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(6),
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 8, 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(
                                    width: 1, color: AppColors.lightGray),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.lightGray,
                                  child: SvgPicture.asset(
                                    'assets/svg/person.svg',
                                    color: AppColors.primary,
                                    width: 24,
                                  ),
                                ),
                                title: const Text('Chuyển sang Nhà phân phối'),
                                subtitle: const Text(
                                    'Phần này dành cho Nhà phân phối'),
                                trailing: const Icon(
                                    Icons.keyboard_arrow_right_rounded),
                              )),
                        );
                      }
                      return Container();
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<PersonalBloc>().add(LogoutEvent());
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.routeLogin,
                          (route) => false,
                        );
                      },
                      icon:
                          SvgPicture.asset('assets/svg/logout.svg', width: 24),
                      label: const Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: const Color(0xffe3e5e5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

final items = [
  SettingItem(
    icon: 'assets/svg/person.svg',
    title: 'Chỉnh sửa thông tin',
    subtitle: 'Xem chỉnh sửa thông tin người dùng',
    route: Routes.routeEditProfile,
  ),
  SettingItem(
    icon: 'assets/svg/cube.svg',
    title: 'Đơn đặt xe',
    subtitle: 'Xem tất cả đơn đặt xe',
    route: Routes.routeAllOrder,
  ),
  SettingItem(
    icon: 'assets/svg/truck.svg',
    title: 'Địa chỉ',
    subtitle: 'Quản lý địa chỉ của bạn',
    route: Routes.routeDeliveryAddresses,
  ),
  SettingItem(
    icon: 'assets/svg/bell.svg',
    title: 'Thông báo',
    subtitle: 'Quản lý thông báo',
    route: Routes.routeDeliveryAddresses,
  ),
  SettingItem(
    icon: 'assets/svg/payment.svg',
    title: 'Thanh toán',
    subtitle: 'Xem và quản lý thanh toán của bạn',
    route: Routes.routeAllOrder,
  ),
  SettingItem(
    icon: 'assets/svg/help.svg',
    title: 'Hỗ trợ',
    subtitle: 'Xem để được hỗ trợ',
    route: Routes.routeAllOrder,
  ),
];

class SettingItem {
  final String icon;
  final String title;
  final String subtitle;
  final String route;
  SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}
