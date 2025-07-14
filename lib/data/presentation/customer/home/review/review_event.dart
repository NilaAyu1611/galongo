part of 'review_bloc.dart';

@immutable
abstract class ReviewEvent {}

class SubmitReview extends ReviewEvent {
  final ReviewRequestModel request;
  SubmitReview(this.request);
}

class LoadReviews extends ReviewEvent {}
