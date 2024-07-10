import 'dart:io';

import 'package:carx/features/model/brand.dart';
import 'package:carx/features/presentation/manage_add_car/bloc/add_car_event.dart';
import 'package:carx/features/presentation/manage_add_car/bloc/add_car_state.dart';
import 'package:carx/features/reponsitories/car/car_reponsitory.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_rx/get_rx.dart';

import 'package:image_picker/image_picker.dart';

class AddCarBloc extends Bloc<AddCarEvent, AddCarState> {
  final ImagePicker _picker = ImagePicker();
  CarReponsitory reponsitory;
  AddCarBloc(this.reponsitory) : super(AddCarState.initial()) {
    on<GetDistributorIdEvent>(
      (event, emit) => emit(
        state.copyWith(distributorId: event.id),
      ),
    );
    on<FetchListBrandEvent>((event, emit) async {
      List<Brand> brands = await reponsitory.fetchBrands();
      emit(state.copyWith(brands: brands));
    });
    on<ChangeNameCarEvent>(
      (event, emit) => emit(
        state.copyWith(nameCar: event.text),
      ),
    );
    on<ChangeDescriptionsCarEvent>(
      (event, emit) => emit(
        state.copyWith(descriptions: event.text),
      ),
    );
    on<ChangePriceCarEvent>(
      (event, emit) => emit(
        state.copyWith(price: event.text),
      ),
    );
    on<ChangeBrandCarEvent>(
      (event, emit) => emit(
        state.copyWith(brandId: event.id),
      ),
    );
    on<ChangeQuantityCarEvent>(
      (event, emit) => emit(
        state.copyWith(quantity: event.text),
      ),
    );
    on<ChangeSeatsCarEvent>(
      (event, emit) => emit(
        state.copyWith(seats: event.text),
      ),
    );
    on<ChangeTopSpeedCarEvent>(
      (event, emit) => emit(
        state.copyWith(topSpeed: event.text),
      ),
    );
    on<ChangeHorsePowerCarEvent>(
      (event, emit) => emit(
        state.copyWith(horsePower: event.text),
      ),
    );
    on<ChangeEngineCarEvent>(
      (event, emit) => emit(
        state.copyWith(engine: event.text),
      ),
    );
    on<PickImageFromGalleryEvent>(
      (event, emit) => _pickImageFromGallery(event, emit),
    );
    on<CaptureImageFromCameraEvent>(
      (event, emit) => _captureImageFromCamera(event, emit),
    );
    on<AddCarToServerEvent>(
      (event, emit) => _addCarToServer(event, emit),
    );
  }

  void _pickImageFromGallery(
    PickImageFromGalleryEvent event,
    Emitter emit,
  ) async {
    final List<XFile> imageXFiles = await _picker.pickMultiImage();
    List<File> imageFiles = state.imageFiles;
    if (imageXFiles.isNotEmpty) {
      for (int i = 0; i < imageXFiles.length; i++) {
        imageFiles.addIf(imageFiles.length < 4, File(imageXFiles[i].path));
      }
      emit(state.copyWith(imageFiles: imageFiles));
    }
  }

  void _captureImageFromCamera(
    CaptureImageFromCameraEvent event,
    Emitter emit,
  ) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final imageFile = File(image.path);
      emit(state.copyWith(imageFiles: state.imageFiles..add(imageFile)));
    }
  }

  void _addCarToServer(AddCarToServerEvent event, Emitter emit) async {
    emit(state.copyWith(statusAddCar: AddCarStatus.loading));
    bool checkField = false;
    Map<String, dynamic> mapCar = {};
    mapCar['distributor_id'] = state.distributorId;
    if (state.imageFiles.isNotEmpty) {
      mapCar['image'] = await MultipartFile.fromFile(state.imageFiles[0].path);
    } else {
      emit(state.copyWith(
        statusAddCar: AddCarStatus.failure,
        textError: 'Vui lòng thêm ảnh xe.',
      ));
      checkField = true;
    }
    if (!checkField) {
      checkField = _checkAndSetField(
          'name', state.nameCar, 'Vui lòng nhập tên xe.', mapCar, emit);
    }
    if (!checkField) {
      checkField = _checkAndSetField(
          'price', state.price, 'Vui lòng thêm giá thuê xe.', mapCar, emit);
    }
    if (!checkField) {
      checkField = _checkAndSetField('quantity', state.quantity,
          'Vui lòng thêm số lượng xe cho thuê.', mapCar, emit);
    }
    if (!checkField) {
      checkField = _checkAndSetField('brand_id', state.brandId,
          'Vui lòng chọn thương hiệu của xe.', mapCar, emit);
    }
    if (!checkField) {
      checkField = _checkAndSetField(
          'seats', state.seats, 'Vui lòng thêm chỗ ngồi của xe.', mapCar, emit);
    }
    if (!checkField) {
      checkField = _checkAndSetField('top_speed', state.topSpeed,
          'Vui lòng thêm tốc độ của xe.', mapCar, emit);
    }
    if (!checkField) {
      checkField = _checkAndSetField('horse_power', state.horsePower,
          'Vui lòng thêm mã lực của xe.', mapCar, emit);
    }
    if (!checkField) {
      checkField = _checkAndSetField('engine', state.engine,
          'Vui lòng thêm động cơ của xe.', mapCar, emit);
    }
    if (!checkField) {
      checkField = _checkAndSetField('descriptions', state.descriptions,
          'Vui lòng thêm mô tả của xe.', mapCar, emit);
    }

    if (!checkField) {
      try {
        await reponsitory.addCar(mapCar);
        emit(state.copyWith(statusAddCar: AddCarStatus.success));
      } catch (e) {
        emit(state.copyWith(statusAddCar: AddCarStatus.failure));
      }
    }
    emit(state.copyWith(statusAddCar: AddCarStatus.initial));
  }

  bool _checkAndSetField(
    String field,
    dynamic value,
    String errorMessage,
    Map<String, dynamic> mapCar,
    Emitter emit,
  ) {
    if (value.isNotEmpty) {
      mapCar[field] = value;
      return false;
    } else {
      emit(state.copyWith(
        statusAddCar: AddCarStatus.failure,
        textError: errorMessage,
      ));
      return true;
    }
  }
}
