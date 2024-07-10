abstract class CarByBrandEvent {}

class FetchCarsByBrand extends CarByBrandEvent {
  final int brandId;
  FetchCarsByBrand({required this.brandId});
}
