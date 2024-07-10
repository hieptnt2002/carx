import 'package:carx/features/model/car_review.dart';
import 'package:carx/features/model/order_management.dart';

class DashboardState {
  final List<CarReview> reviews;
  final List<OrderManagement> orderDetails;
  final int numPending;
  final int numCancelled;
  final int numRefund;
  const DashboardState({
    required this.reviews,
    required this.orderDetails,
    required this.numPending,
    required this.numCancelled,
    required this.numRefund,
  });
  DashboardState.initial()
      : reviews = [],
        orderDetails = [],
        numPending = 0,
        numCancelled = 0,
        numRefund = 0;
  DashboardState copyWith({
    List<CarReview>? reviews,
    List<OrderManagement>? orderDetails,
    int? numPending,
    int? numCancelled,
    int? numRefund,
  }) =>
      DashboardState(
        reviews: reviews ?? this.reviews,
        orderDetails: orderDetails ?? this.orderDetails,
        numPending: numPending ?? this.numPending,
        numCancelled: numCancelled ?? this.numCancelled,
        numRefund: numRefund ?? this.numRefund,
      );
}
