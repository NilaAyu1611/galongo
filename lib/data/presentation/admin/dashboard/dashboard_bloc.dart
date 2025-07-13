import 'package:bloc/bloc.dart';
import 'package:galongo/data/model/response/dashboard_response_%20model.dart';
import 'package:galongo/data/repository/dashboard_repository.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;

  DashboardBloc({required this.dashboardRepository}) : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) async {
      emit(DashboardLoading());

      final result = await dashboardRepository.getDashboardData();

      result.fold(
  (errorMessage) => emit(DashboardFailure(message: errorMessage)),
  (dashboardResponse) => emit(DashboardSuccess(dashboard: dashboardResponse)),
);

    });
  }
}