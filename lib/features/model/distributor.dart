import 'package:carx/features/model/user.dart';

class Distributor {
  final int id;

  final User user;

  final String descriptions;

  final String location;

  final double latitude;

  final double longtitude;

  const Distributor({
    required this.id,
    required this.user,
    required this.descriptions,
    required this.location,
    required this.latitude,
    required this.longtitude,
  });

  factory Distributor.fromJson(Map<String, dynamic> json) => Distributor(
        id: int.parse(json['id']),
        user: User.fromJson(json['user']),
        descriptions: json['descriptions'],
        location: json['location'] ?? '',
        latitude: double.parse(json['latitude']),
        longtitude: double.parse(json['longtitude']),
      );
}
