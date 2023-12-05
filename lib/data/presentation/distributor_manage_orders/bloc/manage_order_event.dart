import 'package:carx/data/model/order.dart';

abstract class ManageOrderEvent {}

class UpdateOrderEvent extends ManageOrderEvent {
  final String status;
  final String? paymentStatus;
  UpdateOrderEvent({required this.status, this.paymentStatus});
}
 
class GetOrderDataEvent extends ManageOrderEvent{
   final Order order;
  
  GetOrderDataEvent({required this.order});
}