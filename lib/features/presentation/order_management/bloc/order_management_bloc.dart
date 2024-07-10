import 'package:bloc/bloc.dart';
import 'package:carx/features/presentation/order_management/bloc/order_management_event.dart';
import 'package:carx/features/presentation/order_management/bloc/order_management_state.dart';

import 'package:carx/features/reponsitories/order/order_reponsitory.dart';
import 'package:carx/service/auth/auth_provider.dart';

class OrderManagementBloc
    extends Bloc<OrderManagementEvent, OrderManagementState> {
  OrderReponsitory reponsitory;
  AuthProvider provider;
  OrderManagementBloc(this.reponsitory, this.provider)
      : super(OrderManagementState.initial()) {
    on<FetchOrderManagementEvent>(
        (event, emit) => _onFetchOrderManagement(event, emit));

    on<FetchOrderManagementByStatusEvent>(
        (event, emit) => _onFetchOrderManagementByStatus(event, emit));
  }

  void _onFetchOrderManagement(
      FetchOrderManagementEvent event, Emitter emit) async {
    emit(state.copyWith(status: OrderManagementStatus.loading));

    try {
      final String uId = provider.currentUser!.id;
      final orderManagements = await reponsitory.fetchOrders(uId);

      final orderManagementsByStatus = orderManagements.where((e) {
        return e.order.status != 'Đã hoàn thành' && e.order.status != 'Đã hủy';
      }).toList();

      emit(state.copyWith(
        orderManagements: orderManagements,
        orderManagementsByStatus: orderManagementsByStatus,
        status: OrderManagementStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: OrderManagementStatus.failure));
    }
  }

  void _onFetchOrderManagementByStatus(
    FetchOrderManagementByStatusEvent event,
    Emitter emit,
  ) async {
    final orderManagements = state.orderManagements;

    final orderManagementsByStatus = orderManagements.where((e) {
      if (event.status != 'Hoạt động') {
        return e.order.status == event.status;
      } else {
        return e.order.status != 'Đã hoàn thành' && e.order.status != 'Đã hủy';
      }
    }).toList();

    emit(
      state.copyWith(
        orderManagementsByStatus: orderManagementsByStatus,
      ),
    );
  }
}
