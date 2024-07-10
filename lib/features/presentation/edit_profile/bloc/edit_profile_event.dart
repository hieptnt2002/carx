import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {}

class FetchUserEvent extends EditProfileEvent {
  FetchUserEvent();

  @override
  List<Object?> get props => [];
}

class PickImageFromGalleryEvent extends EditProfileEvent {
  PickImageFromGalleryEvent();

  @override
  List<Object?> get props => [];
}

class CaptureImageFromCameraEvent extends EditProfileEvent {
  CaptureImageFromCameraEvent();

  @override
  List<Object?> get props => [];
}

class UserNameEditEvent extends EditProfileEvent {
  final String? name;
  UserNameEditEvent({this.name});

  @override
  List<Object?> get props => [name];
}

class AddressEditEvent extends EditProfileEvent {
  final String? address;
  AddressEditEvent({this.address});

  @override
  List<Object?> get props => [address];
}

class PhoneEditEvent extends EditProfileEvent {
  final String? phone;
  PhoneEditEvent({this.phone});

  @override
  List<Object?> get props => [phone];
}

class GenderSelectionEvent extends EditProfileEvent {
  final String? gender;
  GenderSelectionEvent({this.gender});

  @override
  List<Object?> get props => [gender];
}

class SaveUserInfomationEvent extends EditProfileEvent {
  @override
  List<Object?> get props => [];
}
