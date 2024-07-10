import 'package:equatable/equatable.dart';

class DeliveryAddress extends Equatable {
  final String? id;
  final String? recipientName;
  final String? address;
  final String? phone;
  final String? type;
  final String? userId;
  final int? isSelected;

  const DeliveryAddress({
    this.id,
    this.recipientName,
    this.address,
    this.phone,
    this.type,
    this.userId,
    this.isSelected,
  });
  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
          id: json['id'],
          recipientName: json['recipient_name'],
          address: json['address'],
          phone: json['phone'],
          type: json['type'],
          userId: json['user_id'],
          isSelected: int.parse(json['is_selected']));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['recipient_name'] = recipientName;
    data['address'] = address;
    data['phone'] = phone;
    data['type'] = type;
    data['phone'] = phone;
    data['user_id'] = userId;
    data['is_selected'] = isSelected;
    return data;
  }

  @override
  List<Object?> get props =>
      [id, recipientName, address, phone, type, userId, isSelected];
}
