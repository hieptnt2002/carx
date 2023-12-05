import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/data/model/car_review.dart';
import 'package:carx/data/model/distributor.dart';
import 'package:carx/data/reponsitories/car/car_reponsitory_impl.dart';
import 'package:carx/utilities/app_colors.dart';

import 'package:carx/utilities/app_text.dart';

import 'package:flutter/material.dart';

import 'package:carx/components/item_car.dart';
import 'package:carx/data/model/car.dart';

class ExploreDistributors extends StatefulWidget {
  const ExploreDistributors({Key? key}) : super(key: key);

  @override
  State<ExploreDistributors> createState() => _ExploreDistributorsState();
}

class _ExploreDistributorsState extends State<ExploreDistributors> {
  late final Distributor distributor;
  @override
  void didChangeDependencies() {
    distributor = ModalRoute.of(context)!.settings.arguments as Distributor;
    super.didChangeDependencies();
  }

  double avgRating(List<CarReview> reviews) {
    double sum = 0;
    for (var review in reviews) {
      sum += review.rating;
    }
    double avg = sum / reviews.length;
    return double.parse(avg.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhà phân phối'),
        actions: const [
          Padding(
            padding:  EdgeInsets.only(right: 12),
            child: Icon(Icons.chat_rounded),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 82),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: CachedNetworkImage(
                    imageUrl: distributor.user.image!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/logo-dark.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Text(
                          distributor.user.name!,
                          style:
                              AppText.title2.copyWith(color: AppColors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 4),
                          FutureBuilder(
                            future: CarReponsitoryImpl.response()
                                .fetchReviewByDistributor(distributor.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  '${avgRating(snapshot.data ?? [])}/5',
                                  style: AppText.subtitle3
                                      .copyWith(color: AppColors.white),
                                );
                              }
                              return Text(
                                'N/A',
                                style: AppText.subtitle3
                                    .copyWith(color: AppColors.white),
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: CarReponsitoryImpl.response()
            .fetchCarsByDistributor(distributor.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Car> cars = snapshot.data ?? [];
            return GridView.builder(
              shrinkWrap: true,
              itemCount: cars.length,
              padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
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

          return Container();
        },
      ),
    );
  }
}
