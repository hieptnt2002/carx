

// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Order extends Equatable {
  String? id;
  String? code;
  String? status;
  int? amount;
  int? totalAmount;
  int? deliveryCharges;
  int? quantity;
  String? startTime;
  String? endTime;
  String? paymentstatus;
  String? paymentMethods;
  String? discountAmount;
  String? carId;
  String? userId;
  String? addressId;

  Order(
      {this.id,
      this.code,
      this.status,
      this.amount,
      this.totalAmount,
      this.deliveryCharges,
      this.quantity,
      this.startTime,
      this.endTime,
      this.paymentstatus,
      this.paymentMethods,
      this.discountAmount,
      this.carId,
      this.userId,
      this.addressId});

  Order copyWith({
    String? id,
    String? code,
    String? status,
    int? amount,
    int? totalAmount,
    int? deliveryCharges,
    int? quantity,
    String? startTime,
    String? endTime,
    String? paymentstatus,
    String? paymentMethods,
    String? discountAmount,
    String? carId,
    String? userId,
    String? addressId,
  }) =>
      Order(
          id: id ?? this.id,
          code: code ?? this.code,
          status: status ?? this.status,
          amount: amount ?? this.amount,
          totalAmount: totalAmount ?? this.totalAmount,
          deliveryCharges: deliveryCharges ?? this.deliveryCharges,
          quantity: quantity ?? this.quantity,
          startTime: startTime ?? this.startTime,
          endTime: endTime ?? this.endTime,
          paymentstatus: paymentstatus ?? this.paymentstatus,
          paymentMethods: paymentMethods ?? this.paymentMethods,
          discountAmount: discountAmount ?? this.discountAmount,
          carId: carId ?? this.carId,
          userId: userId ?? this.userId,
          addressId: addressId ?? this.addressId);

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    status = json['status'];
    amount = int.tryParse(json['amount']);
    totalAmount = int.tryParse(json['total_amount']);
    deliveryCharges = int.tryParse(json['delivery_charges']);
    quantity = int.tryParse(json['quantity']);
    startTime = json['start_time'];
    endTime = json['end_time'];
    paymentstatus = json['payment_status'];
    paymentMethods = json['payment_methods'];
    discountAmount = json['discount_amount'];
    carId = json['car_id '];
    userId = json['user_id '];
    addressId = json['address_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['status'] = status;
    data['amount'] = amount;
    data['total_amount'] = totalAmount;
    data['delivery_charges'] = deliveryCharges;
    data['quantity'] = quantity;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['payment_status'] = paymentstatus;
    data['payment_methods'] = paymentMethods;
    data['car_id'] = carId!;
    data['user_id'] = userId;
    data['discount_amount'] = discountAmount ?? '0';
    data['address_id'] = addressId;

    return data;
  }

  @override
  List<Object?> get props => [
        id,
        code,
        status,
        amount,
        totalAmount,
        deliveryCharges,
        quantity,
        startTime,
        endTime,
        paymentstatus,
        paymentMethods,
        discountAmount,
        carId,
        userId,
        addressId
      ];
}
