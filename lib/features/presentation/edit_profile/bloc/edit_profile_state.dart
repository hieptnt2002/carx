import 'dart:io';

import 'package:equatable/equatable.dart';

enum SaveProfileStatus { initial, loading, success, failure }

enum FetchUserStatus { initial, loading, success, failure }

class EditProfileState extends Equatable {
  final File? imageFile;
  final String? imageUrl;
  final String? name;
  final String? defaultName;
  final String? email;
  final String? address;
  final String? phone;
  final String? gender;
  final SaveProfileStatus status;
  final FetchUserStatus userStatus;

  const EditProfileState({
    this.imageFile,
    this.imageUrl,
    this.name,
    this.defaultName,
    this.email,
    this.address,
    this.phone,
    this.gender,
    required this.status,
    required this.userStatus,
  });

  const EditProfileState.initial()
      : imageFile = null,
        imageUrl = null,
        name = null,
        defaultName = null,
        email = null,
        address = null,
        phone = null,
        gender = null,
        status = SaveProfileStatus.initial,
        userStatus = FetchUserStatus.initial;

  EditProfileState copyWith({
    File? imageFile,
    String? imageUrl,
    String? name,
    String? defaultName,
    String? email,
    String? address,
    String? phone,
    String? gender,
    SaveProfileStatus? status,
    FetchUserStatus? userStatus,
  }) =>
      EditProfileState(
          imageFile: imageFile ?? this.imageFile,
          imageUrl: imageUrl ?? this.imageUrl,
          name: name ?? this.name,
          defaultName: defaultName ?? this.defaultName,
          email: email ?? this.email,
          phone: phone ?? this.phone,
          address: address ?? this.address,
          gender: gender ?? this.gender,
          status: status ?? this.status,
          userStatus: userStatus ?? this.userStatus);

  @override
  List<Object?> get props => [
        imageFile,
        imageUrl,
        name,
        defaultName,
        email,
        address,
        phone,
        gender,
        status,
        userStatus
      ];
}
