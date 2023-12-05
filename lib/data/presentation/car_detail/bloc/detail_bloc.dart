import 'package:carx/data/model/car.dart';
import 'package:carx/data/model/car_detail.dart';
import 'package:carx/data/model/car_review.dart';

import 'package:carx/data/model/distributor.dart';
import 'package:carx/data/presentation/car_detail/bloc/detail_event.dart';
import 'package:carx/data/presentation/car_detail/bloc/detail_state.dart';
import 'package:carx/data/reponsitories/car/car_reponsitory.dart';
import 'package:carx/data/local/favorite_car_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarDetailBloc extends Bloc<CarDetailEvent, CarDetailState> {
  CarDetailBloc(
      CarReponsitory carRepository, CarFavoriteService carFavoriteService)
      : super(CarDetailState.initial()) {
    on<FetchCarDetailEvent>(
      (event, emit) async {
        emit(state.copyWith(detailStatus: CarDetailStatus.loading));
        try {
          List<dynamic> results = await Future.wait([
            carRepository.fetchCarDetailsByCarId(event.carId),
            carRepository.fetchDistributorByCarId(event.carId),
            carRepository.fetchReviewBycar(event.carId),
          ]);

          final CarDetail carDetail = results[0];
          final Distributor distributor = results[1];
          final List<CarReview> carReviews = results[2];
          emit(state.copyWith(
            detailStatus: CarDetailStatus.success,
            carDetail: carDetail,
            distributor: distributor,
            carReviews: carReviews,
          ));
        } catch (e) {
          emit(state.copyWith(detailStatus: CarDetailStatus.failure));
        }
      },
    );
    on<FetchRecentlyCarsEvent>(
      (event, emit) async {
        final cars = await carRepository.fetchCars();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final prefCarsId = prefs.getStringList('RE_CAR') ?? [];

        List<Car> recentlyCars = [];
        for (final car in cars) {
          if (prefCarsId.contains(car.id.toString())) {
            recentlyCars.add(car);
          }
        }
        emit(state.copyWith(recentlyCars: recentlyCars));
      },
    );
    on<CheckCarFavoriteEvent>(
      (event, emit) async {
        bool isFavorite =
            await carFavoriteService.isExistCarFavorite(carId: event.carId);
        emit(state.copyWith(isFavorite: isFavorite));
      },
    );
    on<AddOrDeleteCarFavoriteEvent>(
      (event, emit) async {
        bool isFavorite =
            await carFavoriteService.addOrDeleteCarFavorite(car: event.car);
        emit(state.copyWith(isFavorite: isFavorite));
      },
    );
  }
  Map<String, dynamic> rateStar(int starRating, List<CarReview> carReviews) {
    int quantity = 0;
    if (carReviews.isNotEmpty) {
      for (final carReview in carReviews) {
        if (carReview.rating.toInt() == starRating) {
          quantity++;
        }
      }
      final percent = quantity / carReviews.length;
      return {
        'quantity': quantity,
        'percent': percent,
      };
    } else {
      return {
        'quantity': 0,
        'percent': 0.0,
      };
    }
  }

  Map<String, double> averageRating(List<CarReview> carReviews) {
    double totalStarRating = 0;
    if (carReviews.isNotEmpty) {
      for (final carReview in carReviews) {
        totalStarRating += carReview.rating;
      }
      double rate = totalStarRating / carReviews.length;

      final percent = rate / 5;
      return {
        'rate': double.parse(rate.toStringAsFixed(1)),
        'percent': percent,
      };
    } else {
      return {
        'rate': 0.0,
        'percent': 0.0,
      };
    }
  }
}
