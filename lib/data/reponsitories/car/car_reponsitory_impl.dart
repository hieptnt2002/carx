import 'dart:convert';

import 'package:carx/data/model/brand.dart';
import 'package:carx/data/model/car.dart';
import 'package:carx/data/model/car_detail.dart';

import 'package:carx/data/model/dio_response.dart';
import 'package:carx/data/model/distributor.dart';
import 'package:carx/data/model/car_review.dart';
import 'package:carx/data/model/slider.dart';
import 'package:carx/data/model/trending_category.dart';
import 'package:carx/data/reponsitories/car/car_reponsitory.dart';

import 'package:carx/data/client/dio_client.dart';
import 'package:carx/utilities/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class CarReponsitoryImpl implements CarReponsitory {
  final Dio _dio;
  const CarReponsitoryImpl(this._dio);

  factory CarReponsitoryImpl.response() =>
      CarReponsitoryImpl(DioClient.instance.dio);
  @override
  Future<List<Car>> fetchCars() async {
    try {
      final reponse = await _dio.get(FETCH_ALL_CAR);
      if (reponse.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(reponse.data));

        if (dioResponse.status == 'OK') {
          final List<dynamic> responseData = dioResponse.data;
          final List<Car> cars =
              responseData.map((car) => Car.fromJson(car)).toList();

          return cars;
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
  Future<List<Car>> fetchCarsByBrand(int brandId) async {
    try {
      final reponse = await _dio.post(
        FETCH_CARS_BY_BRAND,
        data: FormData.fromMap({'brand_id': brandId}),
      );
      if (reponse.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(reponse.data));

        if (dioResponse.status == 'OK') {
          final List<dynamic> responseData = dioResponse.data;
          final List<Car> cars =
              responseData.map((car) => Car.fromJson(car)).toList();

          return cars;
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
  Future<List<Brand>> fetchBrands() async {
    try {
      final reponse = await _dio.get(FETCH_ALL_BRAND);
      if (reponse.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(reponse.data));

        if (dioResponse.status == 'OK') {
          final List<dynamic> responseData = dioResponse.data;
          final List<Brand> brands =
              responseData.map((brand) => Brand.fromJson(brand)).toList();

          return brands;
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
  Future<CarDetail> fetchCarDetailsByCarId(int id) async {
    try {
      final response = await _dio.post(
        FETCH_CAR_DETAIL,
        data: FormData.fromMap(<String, dynamic>{'id': id}),
      );
      if (response.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(response.data));
        if (dioResponse.status == 'OK') {
          CarDetail cars = CarDetail.fromJson(dioResponse.data);
          return cars;
        } else {
          throw Exception('Not found');
        }
      } else {
        throw Exception('Error request exception');
      }
    } catch (e) {
      throw Exception('Error exception $e');
    }
  }

  @override
  Future<Distributor> fetchDistributorByCarId(int id) async {
    try {
      final response = await _dio.post(
        FETCH_DISTRIBUTOR,
        data: FormData.fromMap(<String, dynamic>{'id': id}),
      );
      if (response.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(response.data));
        if (dioResponse.status == 'OK') {
          Distributor distributor = Distributor.fromJson(dioResponse.data);
          return distributor;
        } else {
          throw Exception('Not found');
        }
      } else {
        throw Exception('Error request exception');
      }
    } catch (e) {
      throw Exception('Error exception $e');
    }
  }

  @override
  Future<List<SliderImage>> fetchSliders() async {
    try {
      final reponse = await _dio.get(FETCH_SLIDER);
      if (reponse.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(reponse.data));

        if (dioResponse.status == 'OK') {
          final List<dynamic> responseData = dioResponse.data;
          final List<SliderImage> sliders = responseData
              .map((slider) => SliderImage.fromJson(slider))
              .toList();

          return sliders;
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
  Future<void> addReview({
    required double rating,
    required String comment,
    required String userId,
    required int carId,
  }) async {
    String timeNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    Map<String, dynamic> mapReview = {
      'rating': rating,
      'comment': comment,
      'created_at': timeNow,
      'user_id': userId,
      'car_id': carId,
    };
    print(comment);
    try {
      final response = await _dio.post(
        ADD_REVIEW,
        data: FormData.fromMap(mapReview),
      );
      if (response.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(response.data));
        if (dioResponse.status == 'OK') {
          print('success');
        }
      }
    } catch (e) {
      throw Exception('Error Sever ${e.toString()}');
    }
  }

  @override
  Future<List<CarReview>> fetchReviewBycar(int carId) async {
    try {
      final reponse = await _dio.post(
        FETCH_REVIEWS,
        data: FormData.fromMap({'car_id': carId}),
      );
      if (reponse.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(reponse.data));

        if (dioResponse.status == 'OK') {
          final List<dynamic> responseData = dioResponse.data;
          final List<CarReview> reviews =
              responseData.map((review) => CarReview.fromJson(review)).toList();

          return reviews;
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
  Future<List<Car>> fetchTopDealsCars() async {
    try {
      final reponse = await _dio.get(FETCH_TOP_CAR);
      if (reponse.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(reponse.data));

        if (dioResponse.status == 'OK') {
          final List<dynamic> responseData = dioResponse.data;
          final List<Car> cars =
              responseData.map((car) => Car.fromJson(car)).toList();

          return cars;
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
  Future<List<TrendingCategory>> fetchTrendingCategories() async {
    try {
      final reponse = await _dio.get(FETCH_TRENDING_CATEGORIES);
      if (reponse.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(reponse.data));

        if (dioResponse.status == 'OK') {
          final List<dynamic> responseData = dioResponse.data;
          final List<TrendingCategory> trendingCategories = responseData
              .map((trendingCategorie) =>
                  TrendingCategory.fromJson(trendingCategorie))
              .toList();

          return trendingCategories;
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
  Future<List<CarReview>> fetchReviewByDistributor(int id) async {
    try {
      final reponse = await _dio.post(
        FETCH_REVIEWS_DISTRIBUTORS,
        data: FormData.fromMap({'id': id}),
      );
      if (reponse.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(reponse.data));

        if (dioResponse.status == 'OK') {
          final List<dynamic> responseData = dioResponse.data;
          final List<CarReview> reviews =
              responseData.map((review) => CarReview.fromJson(review)).toList();

          return reviews;
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
  Future<List<Car>> fetchCarsByDistributor(int id) async {
    try {
      final reponse = await _dio.post(
        FETCH_CARS_BY_DISTRIBUTOR,
        data: FormData.fromMap(
          {'id': id},
        ),
      );
      if (reponse.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(reponse.data));

        if (dioResponse.status == 'OK') {
          final List<dynamic> responseData = dioResponse.data;
          final List<Car> cars =
              responseData.map((car) => Car.fromJson(car)).toList();

          return cars;
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
  Future<void> addCar(Map<String, dynamic> mapCar) async {
    try {
      final reponse = await _dio.post(
        ADD_CAR,
        data: FormData.fromMap(
          mapCar,
        ),
      );
      if (reponse.statusCode == 200) {
        DioReponse dioResponse = DioReponse.fromJson(jsonDecode(reponse.data));

        if (dioResponse.status == 'OK') {
          print('success');
        } else {
          print('failure');
        }
      } else {
        throw Exception('Error request exception');
      }
    } catch (e) {
      throw Exception('Failed to fetch cars: $e');
    }
  }
}
