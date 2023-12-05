import 'package:bloc/bloc.dart';
import 'package:carx/data/model/brand.dart';
import 'package:carx/data/model/car.dart';
import 'package:carx/data/presentation/categories/bloc/categories_event.dart';
import 'package:carx/data/presentation/categories/bloc/categories_state.dart';

import 'package:carx/data/reponsitories/car/car_reponsitory.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(CarReponsitory reponsitory) : super(CategoriesState.initial()) {
    on<FetchDataEvent>(
      (event, emit) async {
            emit(state.copyWith(status: CategoriesStatus.loading));
        try {
          final futures = await Future.wait([
            reponsitory.fetchBrands(),
            reponsitory.fetchCars(),
          ]);

          final brands = futures[0] as List<Brand>;
          final cars = futures[1] as List<Car>;
        
          List<Car> carsbyBrand =
              cars.where((car) => car.brandName == brands.first.name).toList();
          emit(state.copyWith(
            status: CategoriesStatus.success,
            brands: brands,
            cars: cars,
            carsByBrand: carsbyBrand,
            
          ));
        } catch (e) {
          emit(state.copyWith(status: CategoriesStatus.failure));
        }
      },
    );
     on<BrandSelectionTabEvent>((event, emit) {
      List<Car> cars = state.cars;
      List<Car> carsbyBrand =
          cars.where((car) => car.brandName == event.brandName).toList();
      emit(state.copyWith(
          carsByBrand: carsbyBrand, selectedTab: event.selectedTab));
    });
  }
}
