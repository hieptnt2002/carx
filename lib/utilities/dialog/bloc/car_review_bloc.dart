import 'package:carx/features/reponsitories/car/car_reponsitory.dart';
import 'package:carx/service/auth/auth_service.dart';
import 'package:carx/utilities/dialog/bloc/car_review_event.dart';
import 'package:carx/utilities/dialog/bloc/car_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarReviewBloc extends Bloc<CarReviewEvent, CarReviewState> {
  CarReviewBloc(CarReponsitory reponsitory)
      : super(const CarReviewState.initial()) {
    on<CommentInputCarReviewEvent>(
      (event, emit) {
        emit(state.copyWith(comment: event.comment));
      },
    );

    on<StarRatingVoteEvent>(
      (event, emit) {
        emit(state.copyWith(starRating: event.starRating));
      },
    );

    on<SubmitCarReviewEvent>(
      (event, emit) async {
        emit(state.copyWith(status: CarReviewStatus.loading));
        String uId = AuthService.firebase().currentUser!.id;
        String comment = state.comment;
        double rating = state.starRating;
        try {
          await reponsitory.addReview(
            rating: rating,
            comment: comment,
            userId: uId,
            carId: event.carId,
          );
          emit(state.copyWith(status: CarReviewStatus.success));
        } catch (e) {
          emit(state.copyWith(status: CarReviewStatus.failure));
        }
        emit(state.copyWith(status: CarReviewStatus.initial));
      },
    );
  }
}
