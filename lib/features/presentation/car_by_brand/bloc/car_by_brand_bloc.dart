import 'package:bloc/bloc.dart';
import 'package:carx/features/presentation/car_by_brand/bloc/car_by_brand_event.dart';
import 'package:carx/features/presentation/car_by_brand/bloc/car_by_brand_state.dart';

import 'package:carx/features/model/car.dart';

import 'package:carx/features/reponsitories/car/car_reponsitory.dart';

class CarByBrandBloc extends Bloc<CarByBrandEvent, CarByBrandState> {
  CarByBrandBloc(CarReponsitory reponsitory) : super(CarByBrandInitial()) {
    on<FetchCarsByBrand>(
      (event, emit) async {
        emit(CarByBrandLoading());
        try {
          final List<Car> cars =
              await reponsitory.fetchCarsByBrand(event.brandId);
          emit(CarByBrandSuccess(cars: cars));
        } catch (e) {
          emit(CarByBrandFailure(error: e.toString()));
        }
      },
    );
  }
}
