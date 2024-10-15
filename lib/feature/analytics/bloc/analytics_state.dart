part of 'analytics_bloc.dart';

class AnalyticsState extends Equatable {
  @override
  List<Object> get props => [];
}

class AnalyticsInitialState extends AnalyticsState {  @override
List<Object> get props => [];}

class AnalyticsLoadingState extends AnalyticsState {  @override
List<Object> get props => [];}

class AnalyticsLoadedState extends AnalyticsState {
  final List<UserAnalytics> analytics;

  AnalyticsLoadedState(this.analytics);
  @override
  List<Object> get props => [analytics];
}

class AnalyticsErrorState extends AnalyticsState {
  final String error;

  AnalyticsErrorState(this.error);
  @override
  List<Object> get props => [error];
}