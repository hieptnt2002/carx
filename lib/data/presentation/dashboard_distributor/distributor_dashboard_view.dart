import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/data/model/distributor.dart';
import 'package:carx/data/presentation/dashboard_distributor/bloc/dashboard_bloc.dart';
import 'package:carx/data/presentation/dashboard_distributor/bloc/dashboard_event.dart';
import 'package:carx/data/presentation/dashboard_distributor/bloc/dashboard_state.dart';
import 'package:carx/data/presentation/dashboard_distributor/distributor_reviews.dart';
import 'package:carx/data/presentation/dashboard_distributor/explore_distributors.dart';
import 'package:carx/data/presentation/manage_add_car/manage_cars.dart';
import 'package:carx/data/reponsitories/car/car_reponsitory_impl.dart';
import 'package:carx/data/reponsitories/order/order_reponsitory_impl.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_routes.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DistributorDashboard extends StatefulWidget {
  const DistributorDashboard({super.key});

  @override
  State<DistributorDashboard> createState() => _DistributorDashboardState();
}

class _DistributorDashboardState extends State<DistributorDashboard> {
  late final Distributor distributor;
  late DashboardBloc dashboardBloc;
  @override
  void didChangeDependencies() {
    distributor = ModalRoute.of(context)!.settings.arguments as Distributor;
    dashboardBloc = DashboardBloc(
        CarReponsitoryImpl.response(), OrderReponsitoryImpl.response());
    dashboardBloc.add(FetchDataDashboardEvent(id: distributor.id));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => dashboardBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đại lý của bạn'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.message),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: CachedNetworkImage(
                            imageUrl: distributor.user.image!,
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/logo-dark.png',
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                distributor.user.name!,
                                style: AppText.title2,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Đại lý của bạn',
                              style: AppText.bodyGrey.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExploreDistributors(),
                                settings:
                                    RouteSettings(arguments: distributor)));
                      },
                      child: Container(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.primary, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Xem shop',
                          style: AppText.bodyPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 32,
                thickness: 4,
                color: AppColors.whiteSmoke,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Đơn hàng',
                      style: AppText.subtitle3,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    GestureDetector(
                      onTap: () {
                         Navigator.pushNamed(
                                context, Routes.routeManageOrders,
                                arguments: {'id': distributor.id, 'tab': 3});
                      },
                      child: Row(
                        children: [
                          Text(
                            'Xem lịch sử đơn hàng',
                            style: AppText.bodyGrey.copyWith(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: AppColors.grey,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  return GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StatusCard(
                          title: '${state.numPending}',
                          status: 'Chờ xác nhận',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.routeManageOrders,
                                arguments: {'id': distributor.id, 'tab': 0});
                          }),
                      StatusCard(
                          title: '${state.numCancelled}',
                          status: 'Đơn hủy',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.routeManageOrders,
                                arguments: {'id': distributor.id, 'tab': 4});
                          }),
                      StatusCard(
                          title: '${state.numRefund}',
                          status: 'Trả xe/Hoàn tiền',
                          onPressed: () {}),
                      StatusCard(
                          title: '${state.reviews.length}',
                          status: 'Phản hồi đánh giá',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DistributorReviews(),
                                    settings: RouteSettings(
                                        arguments: state.reviews)));
                          }),
                    ],
                  );
                },
              ),
              const Divider(
                height: 32,
                thickness: 6,
                color: AppColors.whiteSmoke,
              ),
              GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  DashboardCard(
                    title: 'Quản lý xe',
                    asset: 'assets/images/car-wash.png',
                    color: Colors.lightBlue,
                    onPressed: () {
                      Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ManageCars(),
                                    settings: RouteSettings(
                                        arguments: distributor)));
                    },
                  ),
                  DashboardCard(
                    title: 'Quản lý đơn hàng',
                    asset: 'assets/images/box.png',
                    color: Colors.amberAccent,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.routeManageOrders,
                          arguments: {'id': distributor.id, 'tab': 0});
                    },
                  ),
                  DashboardCard(
                    title: 'Doanh thu',
                    asset: 'assets/images/wallet.png',
                    color: Colors.lightBlue,
                    onPressed: () {},
                  ),
                  DashboardCard(
                    title: 'Lịch sử cho thuê',
                    asset: 'assets/images/history.png',
                    color: Colors.indigo,
                    onPressed: () {},
                  ),
                  DashboardCard(
                    title: 'Phản hồi',
                    asset: 'assets/images/feedback.png',
                    color: Colors.green,
                    onPressed: () {},
                  ),
                  DashboardCard(
                    title: 'Hỗ trợ',
                    asset: 'assets/images/question-mark.png',
                    color: Colors.pinkAccent,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String asset;
  final Color color;
  final Function onPressed;

  const DashboardCard(
      {super.key,
      required this.title,
      required this.asset,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              asset,
              width: 32.0,
              height: 32.0,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: AppText.bodyFontColor,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String status;
  final Function onPressed;

  const StatusCard(
      {super.key,
      required this.title,
      required this.status,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteSmoke,
          borderRadius: BorderRadius.circular(4.0)),
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  style: AppText.subtitle3,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                status,
                style:
                    AppText.body2.copyWith(fontSize: 12, color: AppColors.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
