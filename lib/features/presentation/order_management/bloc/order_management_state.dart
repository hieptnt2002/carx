import 'package:carx/features/model/order_management.dart';
import 'package:equatable/equatable.dart';

enum OrderManagementStatus { initial, loading, success, failure }

class OrderManagementState extends Equatable {
  final List<OrderManagement> orderManagements;
  final List<OrderManagement> orderManagementsByStatus;
  final OrderManagementStatus status;

  const OrderManagementState({
    required this.orderManagements,
    required this.orderManagementsByStatus,
    required this.status,
  });

  OrderManagementState.initial()
      : status = OrderManagementStatus.initial,
        orderManagements = [],
        orderManagementsByStatus = [];

  OrderManagementState copyWith({
    List<OrderManagement>? orderManagements,
    List<OrderManagement>? orderManagementsByStatus,
    OrderManagementStatus? status,
  }) =>
      OrderManagementState(
        orderManagements: orderManagements ?? this.orderManagements,
        orderManagementsByStatus:
            orderManagementsByStatus ?? this.orderManagementsByStatus,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [
        orderManagements,
        orderManagementsByStatus,
        status,
      ];
}
