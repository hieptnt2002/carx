
import 'package:carx/data/reponsitories/order/order_reponsitory.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_management_detail_event.dart';
import 'order_management_detail_state.dart';

class OrderManagementDetailBloc
    extends Bloc<OrderManagementDetailEvent, OrderManagementDetailState> {
  OrderManagementDetailBloc(
    OrderReponsitory reponsitory,
 
  ) : super(InitialOrderManagementDetailState()) {
    on<OrderCancellationEvent>(
      (event, emit) async {
        emit(OrderLoadingCancelState());
        try {
          await reponsitory.updateOrder(
            order: event.order,
            status: 'Đã hủy',
          );
          emit(OrderCancelledSuccessState());
        } catch (e) {
          emit(OrderCancelledFailureState());
        }
         emit(InitialOrderManagementDetailState());
      },
    );
  }
}
