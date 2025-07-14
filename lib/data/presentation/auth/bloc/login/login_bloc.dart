import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:galongo/data/model/request/auth/login_request_model.dart';
import 'package:galongo/data/model/response/auth_response_mode.dart';
import 'package:galongo/data/repository/auth_repository.dart';
import 'package:galongo/services/service_http_client.dart';
import 'package:http/http.dart' as serviceHttpClient;
import 'package:meta/meta.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  
  final ServiceHttpClient serviceHttpClient = ServiceHttpClient();


  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
  LoginRequested event,
  Emitter<LoginState> emit,
) async {
  emit(LoginLoading());

  try {
    final result = await authRepository.login(event.requestModel);

    // Tangani manual hasilnya (hindari async dalam fold)
    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => null);
      emit(LoginFailure(error: failure ?? "Gagal login"));
    } else {
      final responseModel = result.fold((l) => null, (r) => r)!;

      final meResponse = await serviceHttpClient.getWithToken('me');
      final parsed = jsonDecode(meResponse.body);

      final role = parsed['data'] != null ? parsed['data']['role'] : null;

      if (role == null) {
        emit(LoginFailure(error: "Login gagal: Role tidak ditemukan di response /me"));
        return;
      }

      print("✅ Isi parsed JSON: $parsed");

      emit(LoginSuccess(responseModel: responseModel, role: role));
    }
  } catch (e) {
    emit(LoginFailure(error: "Login gagal: ${e.toString()}"));
  }
}

  
  // async {
  //   emit(LoginLoading());

  //   final result = await authRepository.login(event.requestModel);

  //   result.fold(
  //     (l) => emit(LoginFailure(error: l)),
  //     (r) => emit(LoginSuccess(responseModel: r)),
  //   );
  // }

  

}
