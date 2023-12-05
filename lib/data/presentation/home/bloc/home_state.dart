import 'package:carx/data/model/slider.dart';
import 'package:carx/data/model/brand.dart';
import 'package:carx/data/model/car.dart';
import 'package:carx/data/model/trending_category.dart';

import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final List<Brand> brands;
  final List<Car> cars;
  final List<Car> topDealCars;
  final List<SliderImage> sliders;
  final List<TrendingCategory> trendingCategories;
  final int currentIndexSlider;
  final HomeStatus status;

  const HomeState({
    required this.brands,
    required this.cars,
    required this.topDealCars,
    required this.sliders,
    required this.trendingCategories,
    required this.currentIndexSlider,
    required this.status,
  });
  HomeState.initial()
      : brands = [],
        cars = [],
        sliders = [],
        topDealCars = [],
        trendingCategories = [],
        currentIndexSlider = 0,
        status = HomeStatus.initial;

  HomeState copyWith({
    List<Brand>? brands,
    List<Car>? cars,
    List<Car>? topDealCars,
    List<SliderImage>? sliders,
    List<TrendingCategory>? trendingCategories,
    int? currentIndexSlider,
    HomeStatus? status,
  }) =>
      HomeState(
        brands: brands ?? this.brands,
        cars: cars ?? this.cars,
        topDealCars: topDealCars ?? this.topDealCars,
        sliders: sliders ?? this.sliders,
        trendingCategories: trendingCategories ?? this.trendingCategories,
        currentIndexSlider: currentIndexSlider ?? this.currentIndexSlider,
        status: status ?? this.status,
      );

  @override
  List<Object> get props =>
      [brands, cars, topDealCars, sliders, trendingCategories, currentIndexSlider, status];
}
