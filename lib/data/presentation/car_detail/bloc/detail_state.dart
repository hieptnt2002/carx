import 'package:carx/data/model/car.dart';
import 'package:carx/data/model/car_detail.dart';
import 'package:carx/data/model/car_review.dart';

import 'package:carx/data/model/distributor.dart';
import 'package:equatable/equatable.dart';

enum CarDetailStatus { initial, loading, success, failure }

class CarDetailState extends Equatable {
  final CarDetail? carDetail;
  final Distributor? distributor;
  final CarDetailStatus detailStatus;
  final List<CarReview> carReviews;
  final List<Car> recentlyCars;
  final bool isFavorite;
  const CarDetailState({
    this.carDetail,
    this.distributor,
    required this.detailStatus,
    required this.carReviews,
    required this.recentlyCars,
    required this.isFavorite,
  });

  CarDetailState.initial()
      : carDetail = null,
        distributor = null,
        detailStatus = CarDetailStatus.initial,
        carReviews = [],
        recentlyCars = [],
        isFavorite = false;

  CarDetailState copyWith({
    CarDetail? carDetail,
    Distributor? distributor,
    CarDetailStatus? detailStatus,
    List<CarReview>? carReviews,
    List<Car>? recentlyCars,
    bool? isFavorite,
  }) =>
      CarDetailState(
        carDetail: carDetail ?? this.carDetail,
        distributor: distributor ?? this.distributor,
        detailStatus: detailStatus ?? this.detailStatus,
        carReviews: carReviews ?? this.carReviews,
        recentlyCars: recentlyCars ?? this.recentlyCars,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  @override
  List<Object?> get props => [
        carDetail,
        distributor,
        detailStatus,
        carReviews,
        recentlyCars,
        isFavorite,
      ];
}
