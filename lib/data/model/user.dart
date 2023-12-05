import 'dart:io';

import 'package:dio/dio.dart';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final String? address;
  final String? gender;
  final String? token;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.image,
      this.address,
      this.gender,
      this.token});
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        image: json['image'],
        address: json['address'],
        phone: json['phone'],
        gender: json['gender'],
        token: json['token'],
      );
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataUser = <String, dynamic>{};
    dataUser['id'] = id;
    dataUser['name'] = name;
    dataUser['email'] = email;
    dataUser['image'] = image;
    dataUser['address'] = address;
    dataUser['phone'] = phone;
    dataUser['gender'] = gender;
    dataUser['token'] = token;
    return dataUser;
  }

  Future<Map<String, dynamic>> toJsonImageFile(File? imageFile) async {
    final Map<String, dynamic> dataUser = <String, dynamic>{};
    dataUser['id'] = id;
    dataUser['name'] = name;
    dataUser['email'] = email;
    dataUser['address'] = address;
    dataUser['phone'] = phone;
    dataUser['gender'] = gender;

    if (imageFile != null) {
      dataUser['image'] = await MultipartFile.fromFile(imageFile.path);
    }
    return dataUser;
  }


  @override
  List<Object?> get props =>
      [id, name, email, phone, image, address, gender, token];
}
