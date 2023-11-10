import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/view/login/bloc/auth_bloc.dart';
import 'package:carx/view/login/bloc/auth_event.dart';

import 'package:carx/data/features/personal/bloc/personal_bloc.dart';
import 'package:carx/data/features/personal/bloc/personal_event.dart';
import 'package:carx/data/features/personal/bloc/personal_state.dart';
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
  late PersonalBloc bloc;
  @override
  void initState() {
    bloc = PersonalBloc(
      AuthReponsitoryImpl.reponsitory(),
      FirebaseAuthProvider(),
    );
    bloc.add(FetchUserEvent());
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 0,
                  child: Text('Edit Profile'),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text('Log out'),
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
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<PersonalBloc, PersonalState>(
        bloc: bloc,
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
                              bloc: bloc,
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
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
                // const Divider(height: 1, color: Colors.black26),
                const SizedBox(height: 16),
                ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final SettingItem item = items[index];
                    return Container(
                      margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        onTap: () async {
                          final isChange =
                              await Navigator.of(context).pushNamed(item.route);
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
                            trailing:
                                const Icon(Icons.keyboard_arrow_right_rounded),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                    icon: SvgPicture.asset('assets/svg/logout.svg', width: 24),
                    label: const Text(
                      'Logout',
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
    );
  }
}

final items = [
  SettingItem(
    icon: 'assets/svg/person.svg',
    title: 'Edit Profile',
    subtitle: 'view edit profile user',
    route: Routes.routeEditProfile,
  ),
  SettingItem(
    icon: 'assets/svg/cube.svg',
    title: 'Order',
    subtitle: 'view all orders',
    route: Routes.routeAllOrder,
  ),
  SettingItem(
    icon: 'assets/svg/truck.svg',
    title: 'Address',
    subtitle: 'view and manage your address',
    route: Routes.routeDeliveryAddresses,
  ),
  SettingItem(
    icon: 'assets/svg/bell.svg',
    title: 'Notification',
    subtitle: 'view edit profile user',
    route: Routes.routeDeliveryAddresses,
  ),
  SettingItem(
    icon: 'assets/svg/payment.svg',
    title: 'Payment',
    subtitle: 'View and manage your payments',
    route: Routes.routeAllOrder,
  ),
  SettingItem(
    icon: 'assets/svg/help.svg',
    title: 'Support',
    subtitle: 'view for support',
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
