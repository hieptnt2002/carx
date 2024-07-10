// ignore_for_file: must_be_immutable

import 'package:carx/features/model/order.dart';

class PaymentEvent {}

class OrderCarUpdate extends PaymentEvent {
  Order order;
  OrderCarUpdate({required this.order});
}

class SelectionPaymentMethodEvent extends PaymentEvent {
  String itemSelected;
  SelectionPaymentMethodEvent({required this.itemSelected});
}

class PaymentButtonSelectEvent extends PaymentEvent {
  String paymentMethod;
  PaymentButtonSelectEvent({required this.paymentMethod});
}
