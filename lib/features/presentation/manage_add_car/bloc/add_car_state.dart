import 'dart:io';

import 'package:carx/features/model/brand.dart';

enum AddCarStatus { initial, loading, success, failure }

class AddCarState {
  List<File> imageFiles;
  String nameCar;
  String descriptions;
  String brandId;
  int? distributorId;
  String price;
  String quantity;
  String seats;
  String topSpeed;
  String horsePower;
  String engine;
  List<Brand> brands;
  final AddCarStatus statusAddCar;
  final String textError;
  AddCarState({
    required this.imageFiles,
    required this.nameCar,
    required this.descriptions,
    required this.brandId,
    required this.distributorId,
    required this.price,
    required this.quantity,
    required this.seats,
    required this.topSpeed,
    required this.horsePower,
    required this.engine,
    required this.statusAddCar,
    required this.brands,
    required this.textError,
  });
  AddCarState.initial()
      : imageFiles = [],
        nameCar = '',
        descriptions = '',
        brandId = '',
        distributorId = null,
        price = '',
        quantity = '',
        seats = '',
        topSpeed = '',
        horsePower = '',
        engine = '',
        statusAddCar = AddCarStatus.initial,
        brands = [],
        textError = '';
  AddCarState copyWith({
    List<File>? imageFiles,
    String? nameCar,
    String? descriptions,
    String? brandId,
    int? distributorId,
    String? price,
    String? quantity,
    String? seats,
    String? topSpeed,
    String? horsePower,
    String? engine,
    AddCarStatus? statusAddCar,
    List<Brand>? brands,
    String? textError,
  }) =>
      AddCarState(
        imageFiles: imageFiles ?? this.imageFiles,
        nameCar: nameCar ?? this.nameCar,
        descriptions: descriptions ?? this.descriptions,
        brandId: brandId ?? this.brandId,
        distributorId: distributorId ?? this.distributorId,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        seats: seats ?? this.seats,
        topSpeed: topSpeed ?? this.topSpeed,
        horsePower: horsePower ?? this.horsePower,
        engine: engine ?? this.engine,
        statusAddCar: statusAddCar ?? this.statusAddCar,
        brands: brands ?? this.brands,
        textError: textError ?? this.textError,
      );
}
