import 'package:carx/components/item_car.dart';
import 'package:carx/data/model/brand.dart';
import 'package:carx/data/model/car.dart';
import 'package:carx/data/presentation/categories/bloc/categories_bloc.dart';
import 'package:carx/data/presentation/categories/bloc/categories_event.dart';
import 'package:carx/data/presentation/categories/bloc/categories_state.dart';

import 'package:carx/data/reponsitories/car/car_reponsitory_impl.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shimmer/shimmer.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView>
    with TickerProviderStateMixin {
  late CategoriesBloc bloc;
  TabController? controller;

  @override
  void initState() {
    bloc = CategoriesBloc(CarReponsitoryImpl.response());
    bloc.add(FetchDataEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Danh Mục Xe',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.routeSearch);
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
            if (state.status == CategoriesStatus.success) {
              List<Car> cars = state.carsByBrand;
              List<Brand> brands = state.brands;
              controller = TabController(length: brands.length, vsync: this);
              return Column(
                children: [
                  const SizedBox(height: 8),
                  TabBar(
                    controller: controller,
                    isScrollable: true,
                    onTap: (value) {
                      context.read<CategoriesBloc>().add(BrandSelectionTabEvent(
                            selectedTab: value,
                            brandName: brands[value].name,
                          ));
                    },
                    overlayColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    labelPadding:
                        const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    tabs: brands.map((brand) {
                      return Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            color: state.selectedTab == brands.indexOf(brand)
                                ? AppColors.primary
                                : Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: AppColors.primary,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(999)),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 9,
                          ),
                          child: Text(brand.name,
                              style: TextStyle(
                                  color:
                                      state.selectedTab == brands.indexOf(brand)
                                          ? AppColors.secondary
                                          : AppColors.fontColor,
                                  fontSize: 16)),
                        ),
                      );
                    }).toList(),
                    indicatorColor: Colors.transparent,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: cars.length % 2 == 0
                        ? cars.length / 2 * 260 + 8 * cars.length / 2
                        : (cars.length + 1) / 2 * 260 +
                            8 * (cars.length + 1) / 2,
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 0),
                    child: TabBarView(
                      controller: controller,
                      physics: const NeverScrollableScrollPhysics(),
                      children: brands.map(
                        (e) {
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cars.length,
                            itemBuilder: (context, index) {
                              return Align(
                                alignment: Alignment.center,
                                child: ItemCar(car: cars.elementAt(index)),
                              );
                            },
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              mainAxisExtent: 260,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              childAspectRatio: 1.0,
                              maxCrossAxisExtent: 300,
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              );
            }
            return Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 100,
                    height: 30,
                    child: Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.5),
                        highlightColor: Colors.grey,
                        child: Container(
                          width: 70,
                          height: 30,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(999)),
                              color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 10,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
              ),
            );
          }),
        ),
      ),
    );
  }
}
