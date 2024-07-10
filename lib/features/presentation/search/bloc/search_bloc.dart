import 'package:carx/features/model/car.dart';
import 'package:carx/features/presentation/search/bloc/search_event.dart';
import 'package:carx/features/presentation/search/bloc/search_state.dart';
import 'package:carx/features/reponsitories/car/car_reponsitory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  CarReponsitory reponsitory;

  SearchBloc(this.reponsitory) : super(SearchState.initial()) {
    on<FetchCarsSearchEvent>(_onFetchCarEvent);
    on<SearchCarsEvent>(_onSearchCarsEvent);
  }

  Future<void> _onFetchCarEvent(
    FetchCarsSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(fetchCarsStatus: FetchCarsStatus.loading));
    try {
      final List<Car> cars = await reponsitory.fetchCars();

      emit(state.copyWith(
        allCars: cars,
        carsBySearch: cars,
        fetchCarsStatus: FetchCarsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(fetchCarsStatus: FetchCarsStatus.failure));
    }
  }

  void _onSearchCarsEvent(SearchCarsEvent event, Emitter<SearchState> emit) {
    final String text = event.searchText;

    if (text.isEmpty) {
      emit(state.copyWith(status: SearchStatus.empty));
    } else {
      final List<Car> filteredCars = state.allCars
          .where(
            (car) => car.name.toLowerCase().contains(text.toLowerCase()),
          )
          .toList();
      if (filteredCars.isEmpty) {
        emit(state.copyWith(
            carsBySearch: filteredCars, status: SearchStatus.notFound));
      } else {
        emit(state.copyWith(
            carsBySearch: filteredCars, status: SearchStatus.found));
      }
    }
  }

  List<String> getSuggestions(String text, List<Car> cars) {
    List<String> names = cars.map((e) => e.name).toList();
    List<String> suggestions = names
        .where((e) => e.toLowerCase().startsWith(text.toLowerCase()))
        .toList();
    return suggestions;
  }
}
