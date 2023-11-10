import 'package:carx/data/model/order.dart';
import 'package:carx/data/model/order_management.dart';

abstract class OrderReponsitory {
  Future<void> addOrder(Order order);

  Future<List<OrderManagement>> fetchOrders(String uId);
  Future<String> fetchTokenDistributor({required int orderId});

  Future<void> updateOrder({
    required Order order,
    required String status,
    String? paymentStatus,
  });
}
