import 'package:carx/features/presentation/add_delivery_address/bloc/delivery_address_handler_state.dart';
import 'package:carx/features/model/delivery_address.dart';
import 'package:carx/features/reponsitories/auth/auth_reponsitory.dart';
import 'package:carx/service/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'delivery_address_handler_event.dart';

class DeliveryAddressHandlerBloc
    extends Bloc<DeliveryAddressHandlerEvent, DeliveryAddressHandlerState> {
  AuthReponsitory authReponsitory;
  DeliveryAddressHandlerBloc(this.authReponsitory)
      : super(const DeliveryAddressHandlerState.initial()) {
    on<UpdateIdDeliveryAddressEvent>(
      (event, emit) => emit(state.copyWith(id: event.id)),
    );
    on<RecipientNameChangeEvent>(
      (event, emit) => emit(state.copyWith(recipientName: event.fullName)),
    );

    on<PhoneNumberChangeEvent>(
      (event, emit) => emit(state.copyWith(phoneNumber: event.phoneNumber)),
    );

    on<AddressChangeEvent>(
      (event, emit) => emit(state.copyWith(address: event.address)),
    );
    on<TypeAddressChangeEvent>(
      (event, emit) => emit(state.copyWith(typeAddress: event.type)),
    );

    on<DefaultAddressChangeEvent>(
      (event, emit) => emit(state.copyWith(isDefault: event.isDefault)),
    );
    on<AddAddressToServerEvent>(
      (event, emit) => _onAddOrUpdateDeliveryAddressToServerEvent(event, emit),
    );
    on<EditDeliveryAddressToServerEvent>(
      (event, emit) => _onAddOrUpdateDeliveryAddressToServerEvent(event, emit),
    );
    on<DeleteDeliveryAddressToServerEvent>(
      (event, emit) => _onDeleteAddress(event, emit),
    );
  }

  void _onAddOrUpdateDeliveryAddressToServerEvent(
      DeliveryAddressHandlerEvent event, Emitter emit) async {
    emit(state.copyWith(status: DeliveryAddressHandlerStatus.loading));
    String uId = AuthService.firebase().currentUser!.id;
    String? id = state.id;
    String recipientName = state.recipientName;
    String phoneNumber = state.phoneNumber;
    String address = state.address;
    String typeAddress = state.typeAddress;
    int defaultAddress = state.isDefault ? 1 : 0;
    if (recipientName.isEmpty) {
      emit(state.copyWith(
        textError: 'Vui lòng nhập tên đầy đủ của bạn!',
        status: DeliveryAddressHandlerStatus.failure,
      ));
    } else if (phoneNumber.isEmpty) {
      emit(state.copyWith(
        textError: 'Vui lòng điền số điện thoại của bạn!',
        status: DeliveryAddressHandlerStatus.failure,
      ));
    } else if (!isPhoneNumber(phoneNumber) || phoneNumber.length > 11) {
      emit(state.copyWith(
        textError: 'Định dạng số điện thoại không hợp lệ!',
        status: DeliveryAddressHandlerStatus.failure,
      ));
    } else if (address.isEmpty) {
      emit(state.copyWith(
        textError: 'Vui lòng nhập địa chỉ của bạn!',
        status: DeliveryAddressHandlerStatus.failure,
      ));
    } else if (typeAddress.isEmpty) {
      emit(state.copyWith(
        textError: 'Vui lòng chọn loại địa chỉ!',
        status: DeliveryAddressHandlerStatus.failure,
      ));
    } else {
      DeliveryAddress deliveryAddress = DeliveryAddress(
        id: id ?? '',
        recipientName: recipientName,
        address: address,
        phone: phoneNumber,
        isSelected: defaultAddress,
        type: typeAddress,
        userId: uId,
      );
      try {
        await authReponsitory.addDeliveryAddress(uId, deliveryAddress);

        emit(state.copyWith(status: DeliveryAddressHandlerStatus.success));
      } catch (e) {
        emit(state.copyWith(
          textError: 'Lỗi máy chủ',
          status: DeliveryAddressHandlerStatus.failure,
        ));
      }
    }
    emit(state.copyWith(status: DeliveryAddressHandlerStatus.initial));
  }

  void _onDeleteAddress(
      DeleteDeliveryAddressToServerEvent event, Emitter emit) async {
    emit(state.copyWith(status: DeliveryAddressHandlerStatus.loading));
    try {
      bool isDelete = await authReponsitory.deleteDeliveryAddress(state.id!);
      if (isDelete) {
        emit(state.copyWith(status: DeliveryAddressHandlerStatus.success));
      } else {
        emit(state.copyWith(
          status: DeliveryAddressHandlerStatus.failure,
          textError: 'Không thể xóa vì địa chỉ đang được sử dụng!',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: DeliveryAddressHandlerStatus.failure,
        textError: 'Lỗi máy chủ!!!',
      ));
    }
    emit(state.copyWith(status: DeliveryAddressHandlerStatus.initial));
  }

  bool isPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^[0-9]+$');

    return regex.hasMatch(phoneNumber);
  }
}
