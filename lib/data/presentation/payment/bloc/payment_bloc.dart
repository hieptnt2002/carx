// ignore_for_file: use_build_context_synchronously

import 'package:carx/data/model/order.dart';
import 'package:carx/data/presentation/payment/bloc/payment_event.dart';
import 'package:carx/data/presentation/payment/bloc/payment_state.dart';
import 'package:carx/data/reponsitories/order/order_reponsitory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  OrderReponsitory reponsitory;
  PaymentBloc(this.reponsitory) : super(const PaymentState.initial()) {
    on<SelectionPaymentMethodEvent>(
        (event, emit) => _selectionPaymentMethod(event, emit));

    on<OrderCarUpdate>(
        (event, emit) => emit(state.copyWith(order: event.order)));

    on<PaymentButtonSelectEvent>(
        (event, emit) => _onButtonSelectedPayment(event, emit));
  }

  void _selectionPaymentMethod(
    SelectionPaymentMethodEvent event,
    Emitter emit,
  ) {
    Order? order = state.order;
    order = order?.copyWith(
      paymentMethods: event.itemSelected,
      paymentstatus: 'Unpaid',
    );
    emit(state.copyWith(
      selectedPaymentMethod: event.itemSelected,
      order: order,
    ));
  }

  void _onButtonSelectedPayment(
    PaymentButtonSelectEvent event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    if (event.paymentMethod.isEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(
        errorText: 'Vui lòng chọn phương thức thanh toán!',
        status: PaymentStatus.failure,
      ));
    } else {
      try {
        await reponsitory.addOrder(state.order!);
        emit(state.copyWith(
          errorText: '',
          status: PaymentStatus.success,
        ));
      } catch (e) {
        emit(state.copyWith(
          errorText: e.toString(),
          status: PaymentStatus.failure,
        ));
      }
    }

   emit(state.copyWith(status: PaymentStatus.initial));
  }
}
