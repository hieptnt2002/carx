
import 'package:carx/data/model/brand.dart';
import 'package:carx/data/model/car.dart';

import 'package:equatable/equatable.dart';

enum CategoriesStatus { initial, loading, success, failure }

class CategoriesState extends Equatable {
  final List<Brand> brands;
  final List<Car> cars;
  final List<Car> carsByBrand;
  final int currentIndexSlider;
  final CategoriesStatus status;
  final int selectedTab;
  const CategoriesState({
    required this.brands,
    required this.cars,
    required this.carsByBrand,
  
    required this.currentIndexSlider,
    required this.status,
    required this.selectedTab,
  });
  CategoriesState.initial()
      : cars = [],
        brands = [],
      
        carsByBrand = [],
       
        currentIndexSlider = 0,
        status = CategoriesStatus .initial,
        selectedTab = 0;

  CategoriesState copyWith({
    List<Brand>? brands,
    List<Car>? cars,
    List<Car>? carsByBrand,
    int? currentIndexSlider,
    CategoriesStatus ? status,
    int? selectedTab,
  }) =>
      CategoriesState(
        brands: brands ?? this.brands,
        cars: cars ?? this.cars,
        carsByBrand: carsByBrand ?? this.carsByBrand,
       
        currentIndexSlider: currentIndexSlider ?? this.currentIndexSlider,
        status: status ?? this.status,
        selectedTab: selectedTab ?? this.selectedTab,
      );

  @override
  List<Object> get props =>
      [brands, cars, carsByBrand,currentIndexSlider, status, selectedTab];
}
