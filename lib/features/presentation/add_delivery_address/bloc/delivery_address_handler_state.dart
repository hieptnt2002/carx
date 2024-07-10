import 'package:equatable/equatable.dart';

enum DeliveryAddressHandlerStatus { initial, loading, success, failure }

class DeliveryAddressHandlerState extends Equatable {
  final String? id;
  final String recipientName;
  final String phoneNumber;
  final String address;
  final String typeAddress;
  final bool isDefault;
  final DeliveryAddressHandlerStatus status;
  final String textError;
  const DeliveryAddressHandlerState({
    required this.id,
    required this.recipientName,
    required this.phoneNumber,
    required this.address,
    required this.typeAddress,
    required this.isDefault,
    required this.status,
    required this.textError,
  });
  const DeliveryAddressHandlerState.initial()
      : id = null,
        recipientName = '',
        phoneNumber = '',
        address = '',
        typeAddress = 'Home',
        isDefault = false,
        status = DeliveryAddressHandlerStatus.initial,
        textError = '';

  DeliveryAddressHandlerState copyWith({
    String? id,
    String? recipientName,
    String? phoneNumber,
    String? address,
    String? typeAddress,
    bool? isDefault,
    DeliveryAddressHandlerStatus? status,
    String? textError,
  }) =>
      DeliveryAddressHandlerState(
          id: id ?? this.id,
          recipientName: recipientName ?? this.recipientName,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          address: address ?? this.address,
          typeAddress: typeAddress ?? this.typeAddress,
          isDefault: isDefault ?? this.isDefault,
          status: status ?? this.status,
          textError: textError ?? this.textError);
  @override
  List<Object?> get props => [
        id,
        recipientName,
        phoneNumber,
        address,
        typeAddress,
        isDefault,
        status,
        textError
      ];
}
