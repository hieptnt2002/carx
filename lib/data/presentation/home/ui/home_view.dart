// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:carx/components/item_car.dart';
import 'package:carx/components/item_category.dart';

import 'package:carx/components/shimmer_brand.dart';

import 'package:carx/data/presentation/home/bloc/home_bloc.dart';
import 'package:carx/data/presentation/home/bloc/home_event.dart';
import 'package:carx/data/presentation/home/bloc/home_state.dart';
import 'package:carx/data/model/slider.dart';

import 'package:carx/data/reponsitories/car/car_reponsitory_impl.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_routes.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:carx/utilities/navigation_controller.dart';

import 'package:carx/data/model/brand.dart';
import 'package:carx/data/model/car.dart';

import 'package:dots_indicator/dots_indicator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late StreamController sliderController;

  late MainController mainController;

  @override
  void initState() {
    sliderController = StreamController.broadcast();
    mainController = Get.find();

    super.initState();
  }

  @override
  void dispose() {
    sliderController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(CarReponsitoryImpl.response())..add(FetchDataHomeEvent()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Container(
            margin: const EdgeInsets.only(left: 4),
            child: Image.asset(
              'assets/images/logo-light.png',
              fit: BoxFit.cover,
            ),
          ),
          leadingWidth: 99,
          actions: [
            IconButton(
              onPressed: () async {},
              icon: SvgPicture.asset(
                'assets/svg/bell.svg',
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.routeFavorite);
              },
              icon: SvgPicture.asset(
                'assets/svg/favorite.svg',
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.routeSearch);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Color.fromARGB(255, 236, 235, 235)),
                        child: const TextField(
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: 'Tìm kiếm...',
                              enabled: false,
                              prefixIcon: Icon(Icons.search,
                                  size: 24, color: Colors.black54),
                              suffixIcon: Icon(Icons.filter_list,
                                  size: 24, color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ưu Đãi Đặc Biệt',
                            style: AppText.title1,
                          ),
                          Text(
                            'Xem tất cả',
                            style: AppText.body2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state.status == HomeStatus.success) {
                          List<SliderImage> sliders = state.sliders;
                          return Stack(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: 182.0,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 0.8,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {
                                    context
                                        .read<HomeBloc>()
                                        .add(UpdateIndexIndicatorSlider(index));
                                  },
                                ),
                                items: sliders.map((sliders) {
                                  return Builder(
                                    builder: (context) {
                                      return Image.network(
                                        sliders.image,
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 0,
                                right: 0,
                                child: DotsIndicator(
                                  dotsCount: sliders.length,
                                  position: state.currentIndexSlider,
                                  decorator: DotsDecorator(
                                    activeColor: Colors.white,
                                    color: Colors.grey,
                                    size: const Size.square(6.0),
                                    activeSize: const Size(12.0, 6.0),
                                    activeShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                        return Container(
                          height: 182,
                          width: double.infinity,
                          color: AppColors.whiteSmoke,
                          child: const Center(
                            child: SpinKitCircle(
                              color: AppColors.lightGray,
                              size: 60,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                if (state.status == HomeStatus.success) {
                  List<Brand> brands = state.brands.sublist(0, 7);
                  brands.add(
                    const Brand(
                      name: 'Tất cả',
                      image:
                          'https://cdn-icons-png.flaticon.com/128/9542/9542576.png',
                    ),
                  );
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      return ItemCategory(brand: brands.elementAt(index));
                    },
                    itemCount: brands.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  );
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 6.0,
                    crossAxisSpacing: 6.0,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    return shimmerBrand(size: 54);
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                );
              }),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Top Deals',
                  style: AppText.title1,
                ),
              ),
              BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                if (state.status == HomeStatus.success) {
                  List<Car> cars = state.topDealCars;

                  return Container(
                    height: 310,
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 16.0,
                        mainAxisExtent: 250,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index) {
                        return ItemCar(car: cars[index]);
                      },
                      cacheExtent: null,
                      itemCount: cars.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  );
                }
                return Container();
              }),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Danh Mục Thịnh Hành',
                  style: AppText.title1,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state.status == HomeStatus.success) {
                      final trendingCategories = state.trendingCategories;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisExtent: 300,
                                mainAxisSpacing: 16.0,
                                childAspectRatio: 1.0,
                                maxCrossAxisExtent: 160),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl: trendingCategories[index].image,
                                  width: 300,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/logo-dark.png',
                                    width: 300,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Center(
                                  child: Text(
                                trendingCategories[index].title,
                                style: AppText.header.copyWith(
                                  color: AppColors.white,
                                  fontSize: 24,
                                ),
                              ))
                            ],
                          );
                        },
                        shrinkWrap: true,
                        itemCount: trendingCategories.length,
                        scrollDirection: Axis.horizontal,
                      );
                    }
                    return Container();
                  },
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Đã xem gần đây',
                  style: AppText.title1,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                child: Text(
                  // 'We show you recently viewed results',
                  'Hiển thị cho bạn kết quả đã xem gần đây',
                  style: AppText.body2.copyWith(color: AppColors.grey),
                ),
              ),
              BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                if (state.status == HomeStatus.success) {
                  List<Car> cars = state.cars;
                  return Container(
                    height: cars.isEmpty ? 0 : 310,
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 16.0,
                        mainAxisExtent: 250,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index) {
                        return ItemCar(car: cars[index]);
                      },
                      itemCount: cars.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  );
                }
                return Container();
              }),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
