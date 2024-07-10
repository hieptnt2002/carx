abstract class DeliveryAddressHandlerEvent {}

class RecipientNameChangeEvent extends DeliveryAddressHandlerEvent {
  String? fullName;
  RecipientNameChangeEvent(this.fullName);
}

class UpdateIdDeliveryAddressEvent extends DeliveryAddressHandlerEvent {
  String? id;
  UpdateIdDeliveryAddressEvent(this.id);
}

class PhoneNumberChangeEvent extends DeliveryAddressHandlerEvent {
  String? phoneNumber;
  PhoneNumberChangeEvent(this.phoneNumber);
}

class AddressChangeEvent extends DeliveryAddressHandlerEvent {
  String? address;
  AddressChangeEvent(this.address);
}

class TypeAddressChangeEvent extends DeliveryAddressHandlerEvent {
  String? type;
  TypeAddressChangeEvent(this.type);
}

class DefaultAddressChangeEvent extends DeliveryAddressHandlerEvent {
  bool? isDefault;
  DefaultAddressChangeEvent(this.isDefault);
}

class AddAddressToServerEvent extends DeliveryAddressHandlerEvent {}

class EditDeliveryAddressToServerEvent extends DeliveryAddressHandlerEvent {}

class DeleteDeliveryAddressToServerEvent extends DeliveryAddressHandlerEvent {}
