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

      final result = await repository.submitReview(event.review);
      result.fold(
        (error) => emit(ReviewFailure(error)),
        (data) => emit(ReviewSuccess(data.message ?? 'Berhasil')),
      );
    });
  }
}