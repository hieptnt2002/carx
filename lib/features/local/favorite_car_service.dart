import 'dart:async';

import 'package:carx/features/model/car.dart';
import 'package:carx/service/auth/auth_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'crud_exceptions.dart';

class CarFavoriteService {
  Database? _db;
  List<CarFavorite> _carFavorites = [];

  static final CarFavoriteService _shared =
      CarFavoriteService._sharedInstance();

  CarFavoriteService._sharedInstance() {
    _carFavoritesStreamController =
        StreamController<List<CarFavorite>>.broadcast(
      onListen: () {
        _carFavoritesStreamController.sink.add(_carFavorites);
      },
    );
  }

  factory CarFavoriteService() => _shared;

  late final StreamController<List<CarFavorite>> _carFavoritesStreamController;

  Stream<List<CarFavorite>> get streamAllCarFavorites {
    String uId = AuthService.firebase().currentUser!.id;
    return _carFavoritesStreamController.stream.map((cars) => cars.where((car) {
          return car.userId == uId;
        }).toList());
  }

  Future<void> _cacheCarFavorites() async {
    _carFavorites = await getAllCarFavorites();
    _carFavoritesStreamController.add(_carFavorites);
  }

  Future<List<CarFavorite>> getAllCarFavorites() async {
    String uId = AuthService.firebase().currentUser!.id;
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final resultQuery = await db
        .query(carFavoriteTable, where: 'user_id = ?', whereArgs: [uId]);

    final carFavorites = resultQuery
        .map((carFavoritesRow) => CarFavorite.fromRow(carFavoritesRow))
        .toList();

    return carFavorites;
  }

  Future<bool> isExistCarFavorite({required int carId}) async {
    String uId = AuthService.firebase().currentUser!.id;
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      carFavoriteTable,
      limit: 1,
      where: 'car_id = ? AND user_id = ?',
      whereArgs: [carId, uId],
    );

    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<int> deleteAllCarFavorite() async {
    String uId = AuthService.firebase().currentUser!.id;
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(
      carFavoriteTable,
      where: 'user_id = ?',
      whereArgs: [uId],
    );

    _carFavorites = [];
    _carFavoritesStreamController.add(_carFavorites);
    return numberOfDeletions;
  }

  Future<bool> addOrDeleteCarFavorite({required Car car}) async {
    await _ensureDbIsOpen();
    bool isCheck = await isExistCarFavorite(carId: car.id);

    if (isCheck) {
      await deleteCarFavorite(carId: car.id);
    } else {
      await addCarFavorite(car: car);
    }
    return !isCheck;
  }

  Future<void> deleteCarFavorite({required int carId}) async {
    String uId = AuthService.firebase().currentUser!.id;
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      carFavoriteTable,
      where: 'car_id = ? AND user_id = ?',
      whereArgs: [carId, uId],
    );

    if (deleteCount == 0) {
      throw CouldNotDeleteCarFavorite();
    } else {
      _carFavorites.removeWhere((carFavorite) => carFavorite.carId == carId);
      _carFavoritesStreamController.add(_carFavorites);
    }
  }

  Future<CarFavorite> addCarFavorite({required Car car}) async {
    String uId = AuthService.firebase().currentUser!.id;
    final db = _getDatabaseOrThrow();

    final carFavorite = CarFavorite(
      id: null,
      carId: car.id,
      name: car.name,
      image: car.image,
      price: car.price,
      brandName: car.brandName,
      brandLogo: car.brandLogo,
      quantity: car.quantity,
      location: car.location ?? 'Not yet',
      rating: car.rating ?? 0.0,
      userId: uId,
    );
    await db.insert(carFavoriteTable, carFavorite.toMap());
    _carFavorites.add(carFavorite);
    _carFavoritesStreamController.add(_carFavorites);
    return carFavorite;
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //already
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createCarFavoriteTable);

      await _cacheCarFavorites();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

class CarFavorite {
  final int? id;
  final int carId;
  final String name;
  final String image;
  final int price;
  final String brandName;
  final String brandLogo;
  final int quantity;
  final String location;
  final double rating;
  final String userId;

  const CarFavorite({
    this.id,
    required this.carId,
    required this.name,
    required this.image,
    required this.price,
    required this.brandName,
    required this.brandLogo,
    required this.quantity,
    required this.location,
    required this.rating,
    required this.userId,
  });

  factory CarFavorite.fromRow(Map<String, dynamic> map) => CarFavorite(
      id: map['id'],
      carId: map['car_id'],
      name: map['name'],
      image: map['image'],
      price: int.tryParse(map['price']) ?? 0,
      brandName: map['brand'],
      brandLogo: map['brand_image'],
      quantity: map['quantity'] ?? 0,
      userId: map['user_id'],
      location: map['location'],
      rating: map['rating']);

  Map<String, dynamic> toMap() => {
        idColumn: id,
        carIdColumn: carId,
        nameColumn: name,
        imageColumn: image,
        priceColumn: price,
        brandColumn: brandName,
        brandImageColumn: brandLogo,
        quantityColumn: quantity,
        locationColumn: location,
        ratingColumn: rating,
        userIdColumn: userId,
      };
}

const dbName = 'xcar.db';
const carFavoriteTable = 'car_favorite';
const idColumn = 'id';
const carIdColumn = 'car_id';
const nameColumn = 'name';
const imageColumn = 'image';
const priceColumn = 'price';
const brandColumn = 'brand';
const brandImageColumn = 'brand_image';
const quantityColumn = 'quantity';
const locationColumn = 'location';
const ratingColumn = 'rating';
const userIdColumn = 'user_id';

const createCarFavoriteTable = '''CREATE TABLE IF NOT EXISTS "car_favorite" (
        "id"	INTEGER NOT NULL,
        "car_id" INTEGER,
        "name"	TEXT,
        "image"	TEXT,
        "price"	TEXT,
        "brand"	TEXT,
        "brand_image" TEXT,
        "quantity" INTEGER,
        "location" TEXT,
        "rating" DOUBLE,
        "user_id"	TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)      
      );''';
