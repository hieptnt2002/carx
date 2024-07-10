import 'package:carx/features/model/order.dart';
import 'package:equatable/equatable.dart';

enum ManageOrderStatus { initial, loading, success, failure }

class ManageOrderState extends Equatable {
  final Order? order;

  final ManageOrderStatus status;
  const ManageOrderState({
    required this.order,
    required this.status,
  });
  const ManageOrderState.initial()
      : order = null,
        status = ManageOrderStatus.initial;

  ManageOrderState copyWith({
    Order? order,
    ManageOrderStatus? status,
  }) =>
      ManageOrderState(
        order: order ?? this.order,
        status: status ?? this.status,
      );
  @override
  List<Object?> get props => [order, status];
}
