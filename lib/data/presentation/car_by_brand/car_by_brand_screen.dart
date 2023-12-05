import 'package:carx/components/shimmer_car.dart';
import 'package:carx/data/presentation/car_by_brand/bloc/car_by_brand_event.dart';
import 'package:carx/data/presentation/car_by_brand/bloc/car_by_brand_state.dart';

import 'package:carx/data/model/brand.dart';

import 'package:carx/data/reponsitories/car/car_reponsitory_impl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carx/components/item_car.dart';
import 'package:carx/data/model/car.dart';

import 'bloc/car_by_brand_bloc.dart';

class CarByBrandScreen extends StatelessWidget {
  const CarByBrandScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brand brand = ModalRoute.of(context)!.settings.arguments as Brand;

    return Scaffold(
      appBar: AppBar(
        title: Text(brand.name),
      ),
      body: BlocProvider(
        create: (context) => CarByBrandBloc(CarReponsitoryImpl.response())
          ..add(FetchCarsByBrand(brandId: brand.id!)),
        child: BlocBuilder<CarByBrandBloc, CarByBrandState>(
          builder: (context, state) {
            if (state is CarByBrandSuccess) {
              List<Car> cars = state.cars;
              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.center,
                      child: ItemCar(car: cars.elementAt(index)),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 260,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 1.0,
                    maxCrossAxisExtent: 300,
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
              child: GridView.builder(
                itemCount: 8,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return shimmerCar();
                },
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: 260,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  childAspectRatio: 1.0,
                  maxCrossAxisExtent: 300,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
