import 'package:carx/features/model/delivery_address.dart';
import 'package:equatable/equatable.dart';

enum DeliveryAddressesStatus { initial, loading, success, failure }

class DeliveryAddressState extends Equatable {
  final List<DeliveryAddress> deliveryAddresses;
  final DeliveryAddress? deliveryAddressSelected;
  final DeliveryAddressesStatus status;
  const DeliveryAddressState({
    required this.deliveryAddresses,
    this.deliveryAddressSelected,
    required this.status,
  });
  DeliveryAddressState.initial()
      : deliveryAddressSelected = null,
        deliveryAddresses = [],
        status = DeliveryAddressesStatus.initial;

  DeliveryAddressState copyWith({
    List<DeliveryAddress>? deliveryAddresses,
    DeliveryAddress? deliveryAddressSelected,
    DeliveryAddressesStatus? status,
  }) =>
      DeliveryAddressState(
        deliveryAddresses: deliveryAddresses ?? this.deliveryAddresses,
        deliveryAddressSelected:
            deliveryAddressSelected ?? this.deliveryAddressSelected,
        status: status ?? this.status,
      );
  @override
  List<Object?> get props =>
      [deliveryAddresses, deliveryAddressSelected, status];
}
