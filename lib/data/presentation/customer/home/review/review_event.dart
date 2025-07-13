part of 'review_bloc.dart';

@immutable
sealed class ReviewEvent {}
class SubmitReview extends ReviewEvent {
  final ReviewRequestModel review;

  SubmitReview(this.review);
}