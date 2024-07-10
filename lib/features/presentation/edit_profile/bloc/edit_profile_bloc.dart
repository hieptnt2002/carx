import 'dart:io';

import 'package:carx/features/presentation/edit_profile/bloc/edit_profile_event.dart';
import 'package:carx/features/presentation/edit_profile/bloc/edit_profile_state.dart';
import 'package:carx/features/model/user.dart';
import 'package:carx/features/reponsitories/auth/auth_reponsitory.dart';
import 'package:carx/service/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  AuthReponsitory authReponsitory;
  final ImagePicker _picker = ImagePicker();

  EditProfileBloc(this.authReponsitory)
      : super(const EditProfileState.initial()) {
    on<FetchUserEvent>(
      (event, emit) => _fetchUser(event, emit),
    );
    on<PickImageFromGalleryEvent>(
      (event, emit) => _pickImageFromGallery(event, emit),
    );

    on<CaptureImageFromCameraEvent>(
      (event, emit) => _captureImageFromCamera(event, emit),
    );

    on<UserNameEditEvent>(
      (event, emit) {
        emit(state.copyWith(name: event.name));
      },
    );

    on<AddressEditEvent>(
      (event, emit) {
        emit(state.copyWith(address: event.address));
      },
    );

    on<PhoneEditEvent>(
      (event, emit) {
        emit(state.copyWith(phone: event.phone));
      },
    );

    on<GenderSelectionEvent>(
      (event, emit) {
        emit(state.copyWith(gender: event.gender));
      },
    );

    on<SaveUserInfomationEvent>(
      (event, emit) => _saveUserInfomation(event, emit),
    );
  }

  void _fetchUser(FetchUserEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(userStatus: FetchUserStatus.loading));

      final uid = AuthService.firebase().currentUser?.id;
      final User user = await authReponsitory.fetUserById(uid!);

      emit(state.copyWith(
        name: user.name,
        defaultName: user.name,
        address: user.address,
        email: user.email,
        imageUrl: user.image,
        gender: user.gender,
        phone: user.phone,
        userStatus: FetchUserStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(userStatus: FetchUserStatus.failure));
    }
  }

  void _pickImageFromGallery(
    PickImageFromGalleryEvent event,
    Emitter emit,
  ) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageFile = File(image.path);
      emit(state.copyWith(imageFile: imageFile));
    }
  }

  void _captureImageFromCamera(
    CaptureImageFromCameraEvent event,
    Emitter emit,
  ) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final imageFile = File(image.path);
      emit(state.copyWith(imageFile: imageFile));
    }
  }

  void _saveUserInfomation(SaveUserInfomationEvent event, Emitter emit) async {
    emit(state.copyWith(status: SaveProfileStatus.loading));
    try {
      final uid = AuthService.firebase().currentUser?.id;
      User user = User(
        id: uid,
        name: state.name,
        email: state.email,
        address: state.address,
        phone: state.phone,
        gender: state.gender,
      );
      await authReponsitory.updateUserInfomation(user, state.imageFile);
      emit(state.copyWith(status: SaveProfileStatus.success));
    } catch (e) {
      emit(state.copyWith(status: SaveProfileStatus.failure));
    }
  }
}
