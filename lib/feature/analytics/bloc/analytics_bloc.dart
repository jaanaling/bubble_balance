import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plinko/core/dependency_injection.dart';
import 'package:plinko/feature/analytics/models/user_analytics.dart';
import 'package:plinko/feature/test/repository/test_repository.dart';
import 'package:plinko/feature/aspects/repository/user_data_repository.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final UserDataRepository userRepository = locator<UserDataRepository>();

  AnalyticsBloc() : super(AnalyticsInitialState()) {
    on<LoadAnalyticsEvent>(_onLoadAnalytics);
    on<SaveAnalyticsEvent>(_onSaveAnalytics);
  }

  Future<void> _onLoadAnalytics(
      LoadAnalyticsEvent event, Emitter<AnalyticsState> emit) async {
    emit(AnalyticsLoadingState());
    try {
      final analytics = await userRepository.getUserAnalytics();
      if (analytics != null) {
        emit(AnalyticsLoadedState(analytics));
      } else {
        emit(AnalyticsErrorState('No analytics found'));
      }
    } catch (e) {
      emit(AnalyticsErrorState(e.toString()));
    }
  }

  Future<void> _onSaveAnalytics(
      SaveAnalyticsEvent event, Emitter<AnalyticsState> emit) async {
    try {
      await userRepository.saveUserAnalytics(event.analytics);
      emit(AnalyticsLoadedState(event.analytics));
    } catch (e) {
      emit(AnalyticsErrorState(e.toString()));
    }
  }
}
