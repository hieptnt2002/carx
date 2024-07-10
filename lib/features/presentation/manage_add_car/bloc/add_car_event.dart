abstract class AddCarEvent {}

class FetchListBrandEvent extends AddCarEvent {}

class AddCarToServerEvent extends AddCarEvent {}

class GetDistributorIdEvent extends AddCarEvent {
  final int id;
  GetDistributorIdEvent(this.id);
}

class ChangeNameCarEvent extends AddCarEvent {
  final String text;
  ChangeNameCarEvent(this.text);
}

class ChangeEngineCarEvent extends AddCarEvent {
  final String text;
  ChangeEngineCarEvent(this.text);
}

class PickImageFromGalleryEvent extends AddCarEvent {}

class CaptureImageFromCameraEvent extends AddCarEvent {}

class ChangeDescriptionsCarEvent extends AddCarEvent {
  final String text;
  ChangeDescriptionsCarEvent(this.text);
}

class ChangeBrandCarEvent extends AddCarEvent {
  final String? id;
  ChangeBrandCarEvent(this.id);
}

class ChangePriceCarEvent extends AddCarEvent {
  final String text;
  ChangePriceCarEvent(this.text);
}

class ChangeQuantityCarEvent extends AddCarEvent {
  final String text;
  ChangeQuantityCarEvent(this.text);
}

class ChangeSeatsCarEvent extends AddCarEvent {
  final String text;
  ChangeSeatsCarEvent(this.text);
}

class ChangeTopSpeedCarEvent extends AddCarEvent {
  final String text;
  ChangeTopSpeedCarEvent(this.text);
}

class ChangeHorsePowerCarEvent extends AddCarEvent {
  final String text;
  ChangeHorsePowerCarEvent(this.text);
}
