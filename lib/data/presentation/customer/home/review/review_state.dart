part of 'review_bloc.dart';

@immutable
abstract class ReviewState {}

class ReviewInitial extends ReviewState {}
class ReviewLoading extends ReviewState {}
class ReviewSubmitSuccess extends ReviewState {
  final String message;
  ReviewSubmitSuccess(this.message);
}
class ReviewLoadSuccess extends ReviewState {
  final List<dynamic> reviews;
  ReviewLoadSuccess(this.reviews);
}
class ReviewFailure extends ReviewState {
  final String error;
  ReviewFailure(this.error);
}