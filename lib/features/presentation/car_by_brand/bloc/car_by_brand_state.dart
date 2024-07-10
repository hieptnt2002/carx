import 'package:carx/features/model/car.dart';

abstract class CarByBrandState {}

class CarByBrandInitial extends CarByBrandState {}

class CarByBrandLoading extends CarByBrandState {}

class CarByBrandSuccess extends CarByBrandState {
  final List<Car> cars;

  CarByBrandSuccess({required this.cars});
}

class CarByBrandFailure extends CarByBrandState {
  final String error;

  CarByBrandFailure({required this.error});
}
