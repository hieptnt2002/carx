import 'package:carx/components/shimmer_car.dart';
import 'package:carx/data/presentation/search/ui/search_result_empty.dart';
import 'package:carx/data/reponsitories/car/car_reponsitory_impl.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carx/components/item_car.dart';
import 'package:carx/data/model/car.dart';
import 'package:carx/data/presentation/search/bloc/search_bloc.dart';
import 'package:carx/data/presentation/search/bloc/search_event.dart';
import 'package:carx/data/presentation/search/bloc/search_state.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late SearchBloc bloc;
  late TextEditingController _searchTextController;

  @override
  void initState() {
    _searchTextController = TextEditingController();
    bloc = SearchBloc(CarReponsitoryImpl.response());
    bloc.add(FetchCarsSearchEvent());
    super.initState();
  }

  @override
  void dispose() {
    // bloc.close();
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm Kiếm Xe'),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => bloc,
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state.fetchCarsStatus == FetchCarsStatus.loading) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return shimmerCar();
                        },
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisExtent: 260,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 1.0,
                          maxCrossAxisExtent: 300,
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state.fetchCarsStatus == FetchCarsStatus.success) {
                List<Car> cars = state.carsBySearch;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            autofocus: true,
                            controller: _searchTextController,
                            decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primary, width: 1)),
                              hintText: 'Tìm kiếm....',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.primary,
                              ),
                              suffixIcon: Visibility(
                                visible: _searchTextController.text.isNotEmpty,
                                child: IconButton(
                                    onPressed: () {
                                      _searchTextController.clear();
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: AppColors.primary,
                                    )),
                              ),
                            ),
                            onSubmitted: (value) {
                              bloc.add(SearchCarsEvent(value));
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search),
                        suggestionsCallback: (pattern) {
                          return bloc.getSuggestions(pattern, state.allCars);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        noItemsFoundBuilder: (context) {
                          return const ListTile(
                            title: Text('Không tìm thấy kết quả nào!'),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          _searchTextController =
                              TextEditingController(text: suggestion);
                          bloc.add(SearchCarsEvent(suggestion));
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      child: Visibility(
                        visible: _searchTextController.text.isNotEmpty,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Kết quả cho',
                                  children: [
                                    const TextSpan(text: ' " '),
                                    TextSpan(
                                      text: _searchTextController.text,
                                      style: AppText.subtitle2,
                                    ),
                                    const TextSpan(text: ' " '),
                                  ],
                                 style: AppText.subtitle1,
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: cars.length.toString(),
                                    style: AppText.subtitle2,
                                  ),
                                  const TextSpan(text: ' '),
                                  const TextSpan(
                                    text: 'tìm thấy',
                                    style: AppText.bodyFontColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state.status == SearchStatus.notFound) {
                          return const SearchResultEmptyWidget();
                        } else {
                          return Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4, 4, 4, 0),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: cars.length,
                              itemBuilder: (context, index) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: ItemCar(car: cars.elementAt(index)),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisExtent: 260,
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                childAspectRatio: 1.0,
                                maxCrossAxisExtent: 300,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return shimmerCar();
                      },
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisExtent: 260,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 1.0,
                        maxCrossAxisExtent: 300,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
