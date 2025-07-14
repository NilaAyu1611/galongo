import 'package:bloc/bloc.dart';
import 'package:galongo/data/model/request/admin/promo_request_model.dart';
import 'package:galongo/data/repository/promo_repository.dart';
import 'package:meta/meta.dart';

part 'promo_event.dart';
part 'promo_state.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  final PromoRepository repository;

  PromoBloc(this.repository) : super(PromoInitial()) {
    on<SubmitPromo>((event, emit) async {
      emit(PromoLoading());
      final result = await repository.addPromo(event.request);
      result.fold(
        (l) => emit(PromoFailure(l)),
        (r) => emit(PromoSuccess(r.message ?? 'Promo berhasil ditambahkan')),
      );
    });

    on<FetchPromoList>((event, emit) async {
      emit(PromoLoading());
      final result = await repository.getAllPromo();
      result.fold(
        (l) => emit(PromoFailure(l)),
        (r) => emit(PromoListLoaded(r)),
      );
    });
  }
}