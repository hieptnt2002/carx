// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:carx/features/model/order.dart';
import 'package:carx/features/presentation/order/bloc/order_event.dart';

import 'package:carx/features/presentation/order/bloc/order_state.dart';

import 'package:carx/features/reponsitories/auth/auth_reponsitory.dart';

import 'package:carx/service/auth/auth_service.dart';

import 'package:carx/utilities/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  AuthReponsitory authReponsitory;
  OrderBloc(this.authReponsitory) : super(const OrderState.initial()) {
    on<FetchDeliveryAddressOrderEvent>(
      (event, emit) => _fetchDeliveryAddress(event, emit),
    );
    on<UpdateDeliveryAddressOrderEvent>(
      (event, emit) =>
          emit(state.copyWith(deliveryAddress: event.deliveryAddress)),
    );

    on<DeliveryUpdated>(
      (event, emit) => emit(
        state.copyWith(delivery: event.delivery),
      ),
    );

    on<CarUpdated>(
      (event, emit) => emit(
        state.copyWith(car: event.car),
      ),
    );
    on<PriceUpdated>(
      (event, emit) => emit(
        state.copyWith(price: event.price),
      ),
    );
    on<FromTimeUpdated>(
      (event, emit) async => _fetchFromTime(event, emit),
    );
    on<EndTimeUpdated>(
      (event, emit) async => _fetchEndTime(event, emit),
    );
    on<OrderButtonClicked>(
      (event, emit) => _onOrderButtonClick(event, emit),
    );
    on<DecrementQuantityOrderEvent>(
      (event, emit) {
        int quantity = state.quantity - 1;
        if (quantity >= 1) {
          int price = state.car!.price * state.rentalDuration * quantity;
          int totalAmount = price + state.delivery;
          emit(state.copyWith(
              quantity: quantity, price: price, totalAmount: totalAmount));
        }
      },
    );
    on<IncrementQuantityOrderEvent>(
      (event, emit) {
        int quantity = state.quantity + 1;
        if (quantity <= state.car!.quantity) {
          int price = state.car!.price * state.rentalDuration * quantity;
          int totalAmount = price + state.delivery;
          emit(state.copyWith(
              quantity: quantity, price: price, totalAmount: totalAmount));
        }
      },
    );
  }

  void _fetchDeliveryAddress(
      FetchDeliveryAddressOrderEvent event, Emitter emit) async {
    emit(state.copyWith(
        deliveryAddressStatus: FetchDeliveryAddressStatus.loading));
    try {
      final uid = AuthService.firebase().currentUser?.id;

      final deliveryAddress =
          await authReponsitory.fetchDeliveryAddressDefault(uid!);

      emit(state.copyWith(
        deliveryAddressStatus: FetchDeliveryAddressStatus.success,
        deliveryAddress: deliveryAddress,
      ));
    } catch (e) {
      emit(state.copyWith(
          deliveryAddressStatus: FetchDeliveryAddressStatus.failure));
    }
  }

  void _fetchFromTime(FromTimeUpdated event, Emitter emit) async {
    DateTime? fromTime = state.startTime;

    final selectedDate = await showDatePicker(
      context: event.context,
      initialDate: fromTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: event.context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        fromTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        emit(state.copyWith(startTime: fromTime));
      }
    }
  }

  void _fetchEndTime(EndTimeUpdated event, Emitter emit) async {
    DateTime? endTime = state.endTime;
    DateTime? fromTime = state.startTime;
    int quantity = state.quantity;
    if (fromTime != null) {
      final selectedDate = await showDatePicker(
        context: event.context,
        initialDate: endTime ?? fromTime.add(const Duration(days: 1)),
        firstDate: fromTime.add(const Duration(days: 1)),
        lastDate: DateTime(2100),
      );

      if (selectedDate != null) {
        final selectedTime = await showTimePicker(
          context: event.context,
          initialTime: TimeOfDay.now(),
        );

        if (selectedTime != null) {
          endTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          Duration duration = endTime.difference(fromTime);
          emit(state.copyWith(rentalDuration: duration.inDays));

          int price = event.pricePerDay * state.rentalDuration * quantity;
          int totalAmount = price + state.delivery;
          emit(state.copyWith(
            endTime: endTime,
            price: price,
            totalAmount: totalAmount,
          ));
        }
      }
    } else {
      ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
        content: Text('Vui lòng chọn thời gian bắt đầu thuê trước!'),
      ));
    }
  }

  void _onOrderButtonClick(OrderButtonClicked event, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));

    if (state.deliveryAddress == null) {
      ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
        content: Text('Vui lòng thêm địa chỉ của bạn trước khi đặt xe!'),
      ));
    } else if (state.startTime == null) {
      ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
        content: Text('Vui lòng chọn thời gian bắt đầu trước!'),
      ));
    } else if (state.endTime == null) {
      ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
        content: Text('Vui lòng chọn thời gian kết thúc thuê!'),
      ));
    } else {
      String strStartTime =
          DateFormat('yyyy-MM-dd HH:mm').format(state.startTime!);
      String strEndTime = DateFormat('yyyy-MM-dd HH:mm').format(state.endTime!);

      String code = generateRandomString(12);
      Order order = Order(
          code: code,
          amount: state.price,
          totalAmount: state.totalAmount,
          startTime: strStartTime,
          endTime: strEndTime,
          deliveryCharges: state.delivery,
          quantity: state.quantity,
          userId: AuthService.firebase().currentUser!.id,
          status: 'Chờ xác nhận',
          carId: state.car!.id.toString(),
          addressId: state.deliveryAddress?.id);

      Map<String, dynamic> mapOrder = {
        'car': state.car,
        'order': order,
        'address': state.deliveryAddress,
      };
      Navigator.of(event.context).pushNamed(
        Routes.routePayment,
        arguments: mapOrder,
      );
    }
    emit(state.copyWith(isLoading: false));
  }
}

String generateRandomString(int length) {
  var random = Random.secure();
  var values = List<int>.generate(length, (i) => random.nextInt(256));
  var randomString = base64Url.encode(values);
  return randomString.substring(0, length);
}
