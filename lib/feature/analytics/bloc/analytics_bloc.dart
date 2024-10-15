import 'package:bloc/bloc.dart';
import 'package:bubblebalance/feature/aspects/models/life_aspect.dart';
import 'package:bubblebalance/feature/aspects/repository/life_aspect_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bubblebalance/core/dependency_injection.dart';
import 'package:bubblebalance/feature/analytics/models/user_analytics.dart';
import 'package:bubblebalance/feature/test/repository/test_repository.dart';
import 'package:bubblebalance/feature/aspects/repository/user_data_repository.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final UserDataRepository userRepository = locator<UserDataRepository>();
    final LifeAspectRepository aspectRepository = locator<LifeAspectRepository>();

  AnalyticsBloc() : super(AnalyticsInitialState()) {
    on<LoadAnalyticsEvent>(_onLoadAnalytics);
  }

  Future<void> _onLoadAnalytics(
      LoadAnalyticsEvent event, Emitter<AnalyticsState> emit) async {
    emit(AnalyticsLoadingState());
    try {
      final analytics = await userRepository.getUserAnalytics();
      final aspects = await aspectRepository.getAspects();
      if (analytics != null) {
        emit(AnalyticsLoadedState(analytics, aspects));
      } else {
        emit(AnalyticsErrorState('No analytics found'));
      }
    } catch (e) {
      emit(AnalyticsErrorState(e.toString()));
    }
  }
}
