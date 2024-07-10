import 'dart:io';

import 'package:carx/features/model/delivery_address.dart';
import 'package:carx/features/model/distributor.dart';
import 'package:carx/features/model/user.dart';

abstract class AuthReponsitory {
  Future<void> createOrUpdateUser({
    required String id,
    String? name,
    String? email,
    String? image,
    String? token,
  });
  Future<User> fetUserById(String uId);
  Future<DeliveryAddress?> fetchDeliveryAddressDefault(String uId);
  Future<List<DeliveryAddress>> fetchDeliveryAddresses(String uId);
  Future<void> addDeliveryAddress(String uId, DeliveryAddress deliveryAddress);
  Future<bool> deleteDeliveryAddress(String id);
  Future<void> updateUserInfomation(User user, File? imageFile);
  Future<Distributor?> fetchDistributorByUid(String uId);
}
