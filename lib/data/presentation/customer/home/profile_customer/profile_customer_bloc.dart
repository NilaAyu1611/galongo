import 'package:bloc/bloc.dart';
import 'package:galongo/data/model/request/customer/customer_profile_request_model.dart';
import 'package:galongo/data/model/response/customer/customer_profile_response_model.dart';
import 'package:galongo/data/repository/profile_customer_repository.dart';
import 'package:meta/meta.dart';

part 'profile_customer_event.dart';
part 'profile_customer_state.dart';

class ProfileCustomerBloc extends Bloc<ProfileCustomerEvent, ProfileCustomerState> {
  final ProfileCustomerRepository repository;

  ProfileCustomerBloc(this.repository) : super(ProfileCustomerInitial()) {
    on<LoadCustomerProfile>((event, emit) async {
      emit(ProfileCustomerLoading());
      final result = await repository.getProfile();
      result.fold(
        (l) => emit(ProfileCustomerError(l)),
        (r) => emit(ProfileCustomerLoaded(r)),
      );
    });

    on<UpdateCustomerProfile>((event, emit) async {
      emit(ProfileCustomerLoading());
      final result = await repository.addOrUpdateProfile(event.request);
      result.fold(
        (l) => emit(ProfileCustomerError(l)),
        (r) => emit(ProfileCustomerUpdated(r.message ?? "Berhasil diperbarui")),
      );
    });
  }
}