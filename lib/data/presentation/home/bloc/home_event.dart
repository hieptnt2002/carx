import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class FetchDataHomeEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class UpdateIndexIndicatorSlider extends HomeEvent {
  final int index;
  const UpdateIndexIndicatorSlider(this.index);
  @override
  List<Object?> get props => [index];
}

