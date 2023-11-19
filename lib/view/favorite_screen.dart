import 'package:carx/data/model/car.dart';
import 'package:carx/data/local/favorite_car_service.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../components/item_car.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late final CarFavoriteService _carFavoriteService;
  @override
  void initState() {
    _carFavoriteService = CarFavoriteService();
    super.initState();
  }

  @override
  void dispose() {
    _carFavoriteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorite'),
      ),
      body: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 0),
          child: FutureBuilder(
              future: _carFavoriteService.getAllCarFavorites(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitCircle(
                    color: AppColors.primary,
                    size: 50,
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return StreamBuilder(
                      stream: _carFavoriteService.streamAllCarFavorites,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Car> cars = snapshot.data!
                              .map((carFavorite) => Car(
                                  id: carFavorite.carId,
                                  name: carFavorite.name,
                                  image: carFavorite.image,
                                  price: carFavorite.price,
                                  brand: carFavorite.brand))
                              .toList();
                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount: cars.length,
                              itemBuilder: (context, index) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: ItemCar(car: cars[index]),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisExtent: 280,
                                mainAxisSpacing: 16.0,
                                crossAxisSpacing: 16.0,
                                childAspectRatio: 1.0,
                                maxCrossAxisExtent: 300,
                              ));
                        }
                        return Container();
                      });
                }
                return Container();
              })),
    );
  }
}
