import 'package:carx/features/model/car.dart';
import 'package:carx/features/model/delivery_address.dart';

import 'package:equatable/equatable.dart';

enum FetchDeliveryAddressStatus { initial, loading, success, failure }

class OrderState extends Equatable {
  final int delivery;

  final DateTime? startTime;
  final DateTime? endTime;
  final int rentalDuration;
  final int totalAmount;
  final int price;
  final bool isLoading;
  final Car? car;
  final int quantity;
  final DeliveryAddress? deliveryAddress;

  final FetchDeliveryAddressStatus deliveryAddressStatus;

  const OrderState({
    required this.delivery,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.rentalDuration,
    required this.totalAmount,
    required this.isLoading,
    required this.car,
    required this.deliveryAddress,
    required this.quantity,
    required this.deliveryAddressStatus,
  });

  const OrderState.initial()
      : delivery = 0,
        startTime = null,
        endTime = null,
        price = 0,
        rentalDuration = 1,
        totalAmount = 0,
        isLoading = false,
        car = null,
        deliveryAddress = null,
        quantity = 1,
        deliveryAddressStatus = FetchDeliveryAddressStatus.initial;

  OrderState copyWith({
    int? delivery,
    String? address,
    DateTime? startTime,
    DateTime? endTime,
    int? price,
    int? rentalDuration,
    int? totalAmount,
    bool? isLoading,
    Car? car,
    DeliveryAddress? deliveryAddress,
    int? quantity,
    FetchDeliveryAddressStatus? deliveryAddressStatus,
  }) {
    return OrderState(
      delivery: delivery ?? this.delivery,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      price: price ?? this.price,
      rentalDuration: rentalDuration ?? this.rentalDuration,
      totalAmount: totalAmount ?? this.totalAmount,
      isLoading: isLoading ?? this.isLoading,
      car: car ?? this.car,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      quantity: quantity ?? this.quantity,
      deliveryAddressStatus:
          deliveryAddressStatus ?? this.deliveryAddressStatus,
    );
  }

  @override
  List<Object?> get props => [
        delivery,
        startTime,
        endTime,
        price,
        rentalDuration,
        totalAmount,
        isLoading,
        car,
        deliveryAddress,
        quantity,
        deliveryAddressStatus,
      ];
}
