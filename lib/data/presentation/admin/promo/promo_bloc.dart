import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/model/request/admin/promo_request_model.dart';
import 'package:galongo/data/repository/promo_repository.dart';
part 'promo_event.dart';
part 'promo_state.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  final PromoRepository repository;

  PromoBloc(this.repository) : super(PromoInitial()) {
    on<LoadPromos>((event, emit) async {
      emit(PromoLoading());
      final result = await repository.getAllPromo();
      result.fold(
        (l) => emit(PromoFailure(l)),
        (r) => emit(PromoLoadSuccess(r)),
      );
    });

    on<AddPromo>((event, emit) async {
      emit(PromoLoading());
      final result = await repository.addPromo(event.request);
      result.fold(
        (l) => emit(PromoFailure(l)),
        (r) => emit(PromoOperationSuccess(r.message ?? 'Promo ditambahkan')),
      );
    });

    on<UpdatePromo>((event, emit) async {
      emit(PromoLoading());
      final result = await repository.updatePromo(event.promoId, event.request);
      result.fold(
        (l) => emit(PromoFailure(l)),
        (r) => emit(PromoOperationSuccess(r.message ?? 'Promo diperbarui')),
      );
    });

    on<DeletePromo>((event, emit) async {
      emit(PromoLoading());
      final result = await repository.deletePromo(event.promoId);
      result.fold(
        (l) => emit(PromoFailure(l)),
        (r) => emit(PromoOperationSuccess(r)),
      );
    });
  }
}
