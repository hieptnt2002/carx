import 'dart:convert';
import 'dart:io';

import 'package:carx/data/model/delivery_address.dart';
import 'package:carx/data/model/dio_response.dart';
import 'package:carx/data/model/distributor.dart';
import 'package:carx/utilities/api_constants.dart';
import 'package:carx/service/auth/auth_exceptions.dart';
import 'package:carx/data/client/dio_client.dart';
import 'package:dio/dio.dart';

import 'package:carx/data/model/user.dart';
import 'package:carx/data/reponsitories/auth/auth_reponsitory.dart';

class AuthReponsitoryImpl implements AuthReponsitory {
  final Dio _dio;

  const AuthReponsitoryImpl(this._dio);
  factory AuthReponsitoryImpl.reponsitory() =>
      AuthReponsitoryImpl(DioClient.instance.dio);

  @override
  Future<void> createOrUpdateUser(
      {required String id,
      String? name,
      String? email,
      String? image,
      String? token}) async {
    try {
      User user =
          User(id: id, email: email, name: name, image: image, token: token);

      final userJson = user.toJson();

      final response = await _dio.post(
        REGISTER,
        data: FormData.fromMap(userJson),
      );
      if (response.statusCode != 200) {
        throw GenericAuthException();
      }
    } catch (e) {
      throw (Exception('Error'));
    }
  }

  @override
  Future<User> fetUserById(String uId) async {
    try {
      final response = await _dio.post(
        FETCH_USER_BY_ID,
        data: FormData.fromMap({'id': uId}),
      );
      if (response.statusCode == 200) {
        DioReponse dioReponse = DioReponse.fromJson(jsonDecode(response.data));

        if (dioReponse.status == 'OK') {
          final User user = User.fromJson(dioReponse.data);
          return user;
        } else {
          return User();
        }
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception('Error Sever');
    }
  }

  @override
  Future<void> updateUserInfomation(User user, File? imageFile) async {
    try {
      Map<String, dynamic> userMap = await user.toJsonImageFile(imageFile);
      final response = await _dio.post(
        UPDATE_USER_INFO,
        data: FormData.fromMap(userMap),
      );
      if (response.statusCode == 200) {
        print('Success ${response.data}');
      } else {
        print('Failled');
      }
    } catch (e) {
      throw (Exception('Error'));
    }
  }

  @override
  Future<DeliveryAddress?> fetchDeliveryAddressDefault(String uId) async {
    try {
      final response = await _dio.post(
        FETCH_DELIVERY_ADDRESS_SELECTED,
        data: FormData.fromMap({'user_id': uId}),
      );
      if (response.statusCode == 200) {
        DioReponse dioReponse = DioReponse.fromJson(jsonDecode(response.data));

        if (dioReponse.status == 'OK' && dioReponse.data != null) {
          final DeliveryAddress deliveryAddress =
              DeliveryAddress.fromJson(dioReponse.data);
          return deliveryAddress;
        } else {
          return null;
        }
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception('Error Sever');
    }
  }

  @override
  Future<List<DeliveryAddress>> fetchDeliveryAddresses(String uId) async {
    try {
      final response = await _dio.post(
        FETCH_DELIVERY_ADDRESSES,
        data: FormData.fromMap({'user_id': uId}),
      );
      if (response.statusCode == 200) {
        DioReponse dioReponse = DioReponse.fromJson(jsonDecode(response.data));

        if (dioReponse.status == 'OK') {
          List<dynamic> reponseData = dioReponse.data;
          List<DeliveryAddress> deliveryAddress = reponseData
              .map((data) => DeliveryAddress.fromJson(data))
              .toList();

          return deliveryAddress;
        } else {
          return [];
        }
      } else {
        throw Exception('Error request exception');
      }
    } catch (e) {
      throw Exception('Failed to fetch cars: $e');
    }
  }

  @override
  Future<void> addDeliveryAddress(
      String uId, DeliveryAddress deliveryAddress) async {
    try {
      final response = await _dio.post(
        ADD_ADDRESS,
        data: FormData.fromMap(deliveryAddress.toJson()),
      );
      if (response.statusCode == 200) {
        print('Success ${response.data}');
      } else {
        print('Failled');
      }
    } catch (e) {
      print(e.toString());
      throw (Exception('Error'));
    }
  }

  @override
  Future<bool> deleteDeliveryAddress(String id) async {
    try {
      final response = await _dio.post(
        DELETE_ADDRESS,
        data: FormData.fromMap({'id': id}),
      );
      if (response.statusCode == 200) {
        DioReponse dioReponse = DioReponse.fromJson(jsonDecode(response.data));
        if (dioReponse.status == 'OK') {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      throw (Exception('Error'));
    }
  }

  @override
  Future<Distributor?> fetchDistributorByUid(String uId) async {
    try {
      final response = await _dio.post(
        FETCH_DISTRIBUTOR_BY_UID,
        data: FormData.fromMap(<String, dynamic>{'id': uId}),
      );
      if (response.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(response.data));
        if (dioResponse.status == 'OK' &&  dioResponse.data != null) {
          final distributor = Distributor.fromJson(dioResponse.data);
          return distributor;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error exception $e');
    }
  }
}
