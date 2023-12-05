import 'package:carx/data/model/car_review.dart';
import 'package:carx/data/model/order_management.dart';
import 'package:carx/data/presentation/dashboard_distributor/bloc/dashboard_event.dart';
import 'package:carx/data/presentation/dashboard_distributor/bloc/dashboard_state.dart';
import 'package:carx/data/reponsitories/car/car_reponsitory.dart';
import 'package:carx/data/reponsitories/order/order_reponsitory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  late final CarReponsitory reponsitory;
  late final OrderReponsitory orderReponsitory;
  DashboardBloc(this.reponsitory,this.orderReponsitory) : super(DashboardState.initial()) {
    on<FetchDataDashboardEvent>(
      (event, emit) => _fetchData(event, emit),
    );
  }
  void _fetchData(FetchDataDashboardEvent event, Emitter emit) async {
    int id = event.id;
    final results = await Future.wait([
      reponsitory.fetchReviewByDistributor(id),
      orderReponsitory.fetchOrdersByDistributor(id),
    ]);
    final reviews = results[0] as List<CarReview>;
    final orderDetails = results[1] as List<OrderManagement>;
    int pending = 0;
    int cancelled = 0;
    int refund = 0;
    for (var orderDetail in orderDetails) {
      String status = orderDetail.order.status!;
      if (status == 'Chờ xác nhận') {
        pending++;
      } else if (status == 'Đã hủy') {
        cancelled++;
      } else if (status == 'Hoàn tiền') {
        refund++;
      }
    }

    emit(state.copyWith(
      reviews: reviews,
      orderDetails: orderDetails,
      numPending: pending,
      numCancelled: cancelled,
      numRefund: refund,
    ));
  }
}
