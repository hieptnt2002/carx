// ignore_for_file: unnecessary_null_comparison

import 'package:carx/features/model/slider.dart';
import 'package:carx/features/model/brand.dart';
import 'package:carx/features/model/car.dart';
import 'package:carx/features/model/trending_category.dart';
import 'package:carx/features/presentation/home/bloc/home_event.dart';
import 'package:carx/features/presentation/home/bloc/home_state.dart';
import 'package:carx/features/reponsitories/car/car_reponsitory.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CarReponsitory repository;

  HomeBloc(this.repository) : super(HomeState.initial()) {
    on<FetchDataHomeEvent>(
      (event, emit) async {
        emit(state.copyWith(status: HomeStatus.loading));
        try {
          final futures = await Future.wait([
            repository.fetchBrands(),
            repository.fetchSliders(),
            repository.fetchTopDealsCars(),
            repository.fetchCars(),
            repository.fetchTrendingCategories(),
          ]);

          final brands = futures[0] as List<Brand>;
          final sliders = futures[1] as List<SliderImage>;
          final topDealCars = futures[2] as List<Car>;
          final cars = futures[3] as List<Car>;
          final trendingCategories = futures[4] as List<TrendingCategory>;

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final prefCarsId = prefs.getStringList('RE_CAR') ?? [];

          List<Car> recentlyCars = [];
          for (final car in cars) {
            if (prefCarsId.contains(car.id.toString())) {
              recentlyCars.add(car);
            }
          }

          emit(state.copyWith(
            status: HomeStatus.success,
            brands: brands,
            sliders: sliders,
            topDealCars: topDealCars,
            cars: recentlyCars,
            trendingCategories: trendingCategories,
          ));
        } catch (e) {
          emit(state.copyWith(status: HomeStatus.failure));
        }
      },
    );

    on<UpdateIndexIndicatorSlider>(
      (event, emit) => emit(
        state.copyWith(currentIndexSlider: event.index),
      ),
    );
  }
}
