part of 'analytics_bloc.dart';

class AnalyticsState {}

class AnalyticsInitialState extends AnalyticsState {}

class AnalyticsLoadingState extends AnalyticsState {}

class AnalyticsLoadedState extends AnalyticsState {
  final List<UserAnalytics> analytics;

  AnalyticsLoadedState(this.analytics);
}

class AnalyticsErrorState extends AnalyticsState {
  final String error;

  AnalyticsErrorState(this.error);
}