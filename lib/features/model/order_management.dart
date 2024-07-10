import 'package:carx/features/model/brand.dart';
import 'package:carx/features/model/car.dart';
import 'package:carx/features/model/delivery_address.dart';
import 'package:carx/features/model/order.dart';
import 'package:equatable/equatable.dart';

class OrderManagement extends Equatable {
  final Car car;
  final Brand brand;
  final Order order;
  final DeliveryAddress deliveryAddress;

  const OrderManagement({
    required this.car,
    required this.brand,
    required this.order,
    required this.deliveryAddress,
  });

  factory OrderManagement.fromJson(Map<String, dynamic> json) =>
      OrderManagement(
        car: Car.fromJson(json['car']),
        brand: Brand.fromJson(json['brand']),
        order: Order.fromJson(json['order']),
        deliveryAddress: DeliveryAddress.fromJson(json['address']),
      );

  @override
  List<Object?> get props => [car, brand, order];
}
