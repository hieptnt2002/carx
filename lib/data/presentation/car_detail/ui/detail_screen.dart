// ignore_for_file: library_private_types_in_public_api, unnecessary_string_interpolations

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/components/item_car.dart';
import 'package:carx/components/rating_bar_widget.dart';
import 'package:carx/components/reviews_car.dart';
import 'package:carx/components/shimmer_brand.dart';

import 'package:carx/data/model/car.dart';
import 'package:carx/data/model/car_detail.dart';
import 'package:carx/data/model/car_review.dart';

import 'package:carx/data/model/distributor.dart';
import 'package:carx/data/presentation/car_detail/bloc/detail_bloc.dart';
import 'package:carx/data/presentation/car_detail/bloc/detail_event.dart';
import 'package:carx/data/presentation/car_detail/bloc/detail_state.dart';

import 'package:carx/data/reponsitories/car/car_reponsitory_impl.dart';
import 'package:carx/data/local/favorite_car_service.dart';
import 'package:carx/utilities/app_colors.dart';

import 'package:carx/utilities/app_routes.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:carx/utilities/util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:percent_indicator/percent_indicator.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class CarDetailView extends StatefulWidget {
  const CarDetailView({Key? key}) : super(key: key);

  @override
  _CarDetailViewState createState() => _CarDetailViewState();
}

class _CarDetailViewState extends State<CarDetailView> {
  late CarDetailBloc carDetailBloc;
  late Car car;
  @override
  void initState() {
    carDetailBloc =
        CarDetailBloc(CarReponsitoryImpl.response(), CarFavoriteService());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    car = ModalRoute.of(context)!.settings.arguments as Car;
    carDetailBloc
      ..add(FetchCarDetailEvent(carId: car.id))
      ..add(CheckCarFavoriteEvent(car.id))
      ..add(FetchRecentlyCarsEvent());
  }

  @override
  void dispose() {
    carDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => carDetailBloc,
      child: BlocBuilder<CarDetailBloc, CarDetailState>(
        builder: (context, state) {
          if (state.detailStatus == CarDetailStatus.loading) {
            return const Scaffold(
              body: Center(
                child: SpinKitCircle(
                  color: Colors.grey,
                  size: 70,
                ),
              ),
            );
          } else if (state.detailStatus == CarDetailStatus.success) {
            final CarDetail carDetail = state.carDetail!;
            final Distributor distributor = state.distributor!;
            final List<CarReview> carReviews = state.carReviews;
            return Scaffold(
              bottomNavigationBar: Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x1A000000),
                      offset: Offset(0, -2),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${formattedAmountCar(carDetail.pricePerDay.toInt())}/day',
                          style: AppText.title2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '0% off',
                          style: AppText.title2
                              .copyWith(color: AppColors.colorSuccess),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(Routes.routeOrder, arguments: car);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        fixedSize: const Size(130, 48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        side: const BorderSide(
                            width: 1, color: AppColors.lightGray),
                      ),
                      child:  Text(
                        'Đặt ngay',
                        style: AppText.subtitle2.copyWith(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                color: AppColors.lightGray,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: car.image,
                                    height: 272,
                                    fit: BoxFit.contain,
                                    errorWidget: (context, url, error) {
                                      return Image.asset(
                                        'assets/images/logo-dark.png',
                                        height: 272,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              AppBar(
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      carDetailBloc.add(
                                          AddOrDeleteCarFavoriteEvent(car));
                                    },
                                    icon: state.isFavorite
                                        ? const Icon(
                                            Icons.favorite_rounded,
                                            color: Colors.redAccent,
                                            size: 26,
                                          )
                                        : const Icon(
                                            Icons.favorite_border_rounded,
                                            color: AppColors.primary,
                                            size: 26,
                                          ),
                                  ),
                                ],
                                backgroundColor: Colors.transparent,
                                elevation: 0.0,
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32)),
                            ),
                            padding: const EdgeInsets.only(
                                top: 12, left: 12, right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    height: 6,
                                    width: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        car.name,
                                        style: AppText.title2,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: 70,
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            shimmerBrand(size: 30),
                                        imageUrl: carDetail.brandImage,
                                        height: 36,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  carDetail.brandName,
                                  style: AppText.title2.copyWith(
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      direction: Axis.horizontal,
                                      rating: carDetailBloc.averageRating(
                                              carReviews)['rate'] ??
                                          0,
                                      itemCount: 5,
                                      itemSize: 24,
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star_rate_rounded,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${carReviews.length} Đánh giá | Phản hồi',
                                      style: AppText.subtitle3.copyWith(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 24,
                                  thickness: 2,
                                  color: Color.fromARGB(255, 245, 244, 244),
                                ),
                                const Text(
                                  'Thông số kỹ thuật',
                                  style: AppText.title2,
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: boxSpecification(
                                              context,
                                              '${carDetail.seats}',
                                              'Chỗ ngồi',
                                              ''),
                                        ),
                                        Expanded(
                                          child: boxSpecification(
                                              context,
                                              '${carDetail.engine}',
                                              'Động cơ',
                                              ''),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: boxSpecification(
                                              context,
                                              '${carDetail.topSpeed}',
                                              'Tốc độ tối đa',
                                              'km/h'),
                                        ),
                                        Expanded(
                                          child: boxSpecification(
                                              context,
                                              '${carDetail.horsePower}',
                                              'Mã lực',
                                              'hp'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Nhà phân phối',
                                  style: AppText.title2,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(999),
                                          child: CachedNetworkImage(
                                            imageUrl: distributor.user.image!,
                                            width: 42,
                                            height: 42,
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              'assets/images/logo-dark.png',
                                              width: 42,
                                              height: 42,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          distributor.user.name!,
                                          style: AppText.title2,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          child: const Card(
                                            child: Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child:
                                                  Icon(Icons.phone, size: 32),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          child: const Card(
                                            child: Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child:
                                                  Icon(Icons.message, size: 32),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const Divider(
                                  height: 24,
                                  thickness: 2,
                                  color: Color.fromARGB(255, 245, 244, 244),
                                ),
                                const Text(
                                  'Mô tả',
                                  style: AppText.title2,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  carDetail.descriptions,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.body2,
                                  textAlign: TextAlign.justify,
                                ),
                                const Divider(
                                  height: 24,
                                  thickness: 2,
                                  color: Color.fromARGB(255, 245, 244, 244),
                                ),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isDismissible: false,
                                      isScrollControlled: true,
                                      showDragHandle: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(24),
                                            topRight: Radius.circular(24)),
                                      ),
                                      enableDrag: true,
                                      builder: (context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              200,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 12),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12),
                                                  child: Text(
                                                    carDetail.descriptions,
                                                    style: AppText.body2,
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Xem tất cả chi tiết',
                                        style: AppText.subtitle3,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 28,
                                  thickness: 4,
                                  color: Color.fromARGB(255, 245, 244, 244),
                                ),
                                const Text(
                                  'Đánh Giá',
                                  style: AppText.title2,
                                ),
                                const SizedBox(height: 12),
                                BlocBuilder<CarDetailBloc, CarDetailState>(
                                  builder: (context, state) {
                                    if (state.detailStatus ==
                                        CarDetailStatus.success) {
                                      List<CarReview> carReviews =
                                          state.carReviews;
                                      if (carReviews.isEmpty) {
                                        return Container(
                                          width: double.infinity,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 32, 0, 48),
                                          child: Center(
                                            child: Text(
                                              'Chưa có đánh giá nào!',
                                              style: AppText.title2.copyWith(
                                                  color: AppColors.grey),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            ratingAndPreview(
                                                context, carReviews),
                                            const SizedBox(height: 12),
                                            ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return ReviewsCardWidget(
                                                  carReview: carReviews[index],
                                                );
                                              },
                                              itemCount: carReviews.length < 2
                                                  ? carReviews.length
                                                  : 2,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  isDismissible: false,
                                                  showDragHandle: true,
                                                  isScrollControlled: true,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(24),
                                                            topRight:
                                                                Radius.circular(
                                                                    24)),
                                                  ),
                                                  enableDrag: true,
                                                  builder: (context) {
                                                    return SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height -
                                                              200,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                'Đánh Giá',
                                                                style: AppText
                                                                    .title2,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      16,
                                                                      16,
                                                                      16,
                                                                      16),
                                                              child:
                                                                  ratingAndPreview(
                                                                      context,
                                                                      carReviews),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      16,
                                                                      0,
                                                                      16,
                                                                      16),
                                                              child: ListView
                                                                  .builder(
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return ReviewsCardWidget(
                                                                    carReview:
                                                                        carReviews[
                                                                            index],
                                                                  );
                                                                },
                                                                itemCount:
                                                                    carReviews
                                                                        .length,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Xem tất cả đánh giá',
                                                    style: AppText.subtitle3,
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 24,
                                              thickness: 2,
                                              color: Color.fromARGB(
                                                  255, 245, 244, 244),
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'Đã xem gần đây',
                                    style: AppText.title1,
                                  ),
                                ),
                                BlocBuilder<CarDetailBloc, CarDetailState>(
                                    builder: (context, state) {
                                  List<Car> cars = state.recentlyCars;
                                  return Container(
                                    height: cars.isEmpty ? 0 : 310,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 16, 0, 16),
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        mainAxisSpacing: 16.0,
                                        mainAxisExtent: 250,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      itemBuilder: (context, index) {
                                        return ItemCar(car: cars[index]);
                                      },
                                      itemCount: cars.length,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state.detailStatus == CarDetailStatus.failure) {
            return const Center(child: Text('Error fetch data'));
          } else {
            return const Center(child: Text('No load car'));
          }
        },
      ),
    );
  }

  Widget boxSpecification(
      BuildContext context, String spec, String specType, String unit) {
    return Card(
      elevation: 0.2,
      color: AppColors.whiteSmoke,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              specType,
              style: const TextStyle(
                  fontSize: 14, color: Color.fromARGB(255, 95, 94, 94)),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: spec,
                  ),
                  const TextSpan(
                    text: ' ',
                  ),
                  TextSpan(
                    text: unit,
                  )
                ],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ratingAndPreview(BuildContext context, List<CarReview> carReviews) {
    double? averagePercent = carDetailBloc.averageRating(carReviews)['percent'];
    double? averageRating = carDetailBloc.averageRating(carReviews)['rate'];
    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 144,
            height: 180,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 244, 244),
                borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 30.0,
                  lineWidth: 7.0,
                  percent: averagePercent ?? 0,
                  center: Text('$averageRating'),
                  progressColor: Colors.green,
                ),
                const SizedBox(height: 4),
                RatingBarIndicator(
                  direction: Axis.horizontal,
                  rating: averageRating ?? 0,
                  itemCount: 5,
                  itemSize: 24,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star_rate_rounded,
                    color: Colors.amber,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${carReviews.length} đánh giá và bình luận',
                    textAlign: TextAlign.center,
                    style: AppText.body2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                int quantity =
                    carDetailBloc.rateStar(index + 1, carReviews)['quantity'] ??
                        0;
                double percent =
                    carDetailBloc.rateStar(index + 1, carReviews)['percent'] ??
                        0.0;
                return RatingBarWidget(
                  rating: index + 1,
                  totalRating: quantity,
                  percent: percent,
                );
              },
              itemExtent: 180 / 5,
              itemCount: 5,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
            ),
          ),
        ],
      ),
    );
  }
}
