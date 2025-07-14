import 'package:bloc/bloc.dart';
import 'package:galongo/data/model/request/customer/review_request_mode.dart' show ReviewRequestModel;
import 'package:galongo/data/repository/review_repository.dart';
import 'package:meta/meta.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository repository;

  ReviewBloc(this.repository) : super(ReviewInitial()) {
    on<SubmitReview>((event, emit) async {
      emit(ReviewLoading());
      final result = await repository.submitReview(event.request);
      result.fold(
        (l) => emit(ReviewFailure(l)),
        (r) => emit(ReviewSubmitSuccess(r.message ?? "Review submitted")),
      );
    });

    on<LoadReviews>((event, emit) async {
      emit(ReviewLoading());
      // NOTE: This requires repository.getAllReviews() to be implemented
      final result = await repository.getAllReviews();
      result.fold(
        (l) => emit(ReviewFailure(l)),
        (r) => emit(ReviewLoadSuccess(r)),
      );
    });
  }
}