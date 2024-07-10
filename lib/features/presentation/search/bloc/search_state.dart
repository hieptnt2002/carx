import 'package:carx/features/model/car.dart';
import 'package:equatable/equatable.dart';

enum SearchStatus { initial, empty, notFound, found }

enum FetchCarsStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final List<Car> allCars;
  final List<Car> carsBySearch;
  final SearchStatus status;
  final FetchCarsStatus fetchCarsStatus;
  const SearchState({
    required this.allCars,
    required this.carsBySearch,
    required this.status,
    required this.fetchCarsStatus,
  });

  SearchState.initial()
      : allCars = [],
        carsBySearch = [],
        status = SearchStatus.initial,
        fetchCarsStatus = FetchCarsStatus.initial;

  SearchState copyWith({
    List<Car>? allCars,
    List<Car>? carsBySearch,
    SearchStatus? status,
    FetchCarsStatus? fetchCarsStatus,
  }) =>
      SearchState(
        allCars: allCars ?? this.allCars,
        carsBySearch: carsBySearch ?? this.carsBySearch,
        status: status ?? this.status,
        fetchCarsStatus: fetchCarsStatus ?? this.fetchCarsStatus,
      );

  @override
  List<Object?> get props => [allCars, carsBySearch, status, fetchCarsStatus];
}
