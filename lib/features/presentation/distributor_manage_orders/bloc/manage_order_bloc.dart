import 'package:carx/features/model/order.dart';
import 'package:carx/features/presentation/distributor_manage_orders/bloc/manage_order_event.dart';
import 'package:carx/features/presentation/distributor_manage_orders/bloc/manage_order_state.dart';
import 'package:carx/features/reponsitories/order/order_reponsitory.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ManageOrderBloc extends Bloc<ManageOrderEvent, ManageOrderState> {
  ManageOrderBloc(OrderReponsitory reponsitory)
      : super(const ManageOrderState.initial()) {
    on<GetOrderDataEvent>((event, emit) {
      emit(state.copyWith(order: event.order));
    });

    on<UpdateOrderEvent>(
      (event, emit) async {
        emit(state.copyWith(status: ManageOrderStatus.loading));
        try {
          await reponsitory.updateOrder(
              order: state.order!,
              status: event.status,
              paymentStatus: event.paymentStatus);
          Order order = state.order!;
          order.status = event.status;
          emit(state.copyWith(status: ManageOrderStatus.success, order: order));
        } catch (e) {
          emit(state.copyWith(status: ManageOrderStatus.failure));
        }
        emit(state.copyWith(status: ManageOrderStatus.initial));
      },
    );
  }
}
