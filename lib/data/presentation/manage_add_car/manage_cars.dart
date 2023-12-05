import 'package:carx/components/item_car.dart';
import 'package:carx/data/model/distributor.dart';
import 'package:carx/data/presentation/manage_add_car/manage_add_car.dart';
import 'package:carx/data/reponsitories/car/car_reponsitory_impl.dart';
import 'package:carx/utilities/app_colors.dart';

import 'package:carx/utilities/app_text.dart';

import 'package:flutter/material.dart';

import 'package:carx/data/model/car.dart';

class ManageCars extends StatefulWidget {
  const ManageCars({Key? key}) : super(key: key);

  @override
  State<ManageCars> createState() => _ManageCarsState();
}

class _ManageCarsState extends State<ManageCars> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Car> cars = [];
  
  final tabs = ['Tất cả', 'Đang bảo dưỡng', 'Chờ duyệt', 'Vi phạm', 'Đã ẩn'];

  late final Distributor distributor;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabs.length);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    distributor = ModalRoute.of(context)!.settings.arguments as Distributor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xe của bạn'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.add),
          )
        ],
        bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColors.secondary,
            controller: _tabController,
            tabs: tabs
                .map(
                  (tab) => Tab(
                    child: Text(
                      tab,
                      style: AppText.body1.copyWith(color: AppColors.white),
                    ),
                  ),
                )
                .toList()),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAddCar(),settings: RouteSettings(arguments: distributor.id)));
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12)),
          child: Text(
            'Thêm xe mới',
            style: AppText.subtitle1.copyWith(color: AppColors.white),
          ),
        ),
      ),
      body: FutureBuilder(
        future: CarReponsitoryImpl.response().fetchCarsByDistributor(distributor.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            cars = snapshot.data ?? [];
            return TabBarView(
              controller: _tabController,
              children: [
                TabItem(cars: cars),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/car-not-found.png',
                        width: 220,
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                      const Text(
                        'Không có xe nào!',
                        style: AppText.bodySmall,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/car-not-found.png',
                        width: 220,
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                      const Text(
                        'Không có xe nào!',
                        style: AppText.bodySmall,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/car-not-found.png',
                        width: 220,
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                      const Text(
                        'Không có xe nào!',
                        style: AppText.bodySmall,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/car-not-found.png',
                        width: 220,
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                      const Text(
                        'Không có xe nào!',
                        style: AppText.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final List<Car> cars;

  const TabItem({super.key, required this.cars});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: cars.length,
      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 72),
      itemBuilder: (context, index) {
        return Align(
          alignment: Alignment.center,
          child: ItemCar(car: cars.elementAt(index)),
        );
      },
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisExtent: 260,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        childAspectRatio: 1.0,
        maxCrossAxisExtent: 300,
      ),
    );
  }
}
