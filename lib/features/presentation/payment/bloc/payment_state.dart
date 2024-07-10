import 'package:carx/features/model/order.dart';
import 'package:equatable/equatable.dart';

enum PaymentStatus { initial, loading, success, failure }

class PaymentState extends Equatable {
  final String selectedPaymentMethod;
  final PaymentStatus status;
  final String errorText;

  final Order? order;

  const PaymentState({
    required this.selectedPaymentMethod,
    required this.status,
    required this.errorText,
    required this.order,
  });

  const PaymentState.initial()
      : status = PaymentStatus.initial,
        selectedPaymentMethod = '',
        errorText = '',
        order = null;

  PaymentState copyWith({
    String? selectedPaymentMethod,
    PaymentStatus? status,
    String? errorText,
    Order? order,
  }) {
    return PaymentState(
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      status: status ?? this.status,
      errorText: errorText ?? this.errorText,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [
        selectedPaymentMethod,
        status,
        errorText,
        order,
      ];
}
