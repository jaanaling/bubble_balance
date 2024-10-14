part of 'analytics_bloc.dart';

class AnalyticsEvent {}

class LoadAnalyticsEvent extends AnalyticsEvent {}

class SaveAnalyticsEvent extends AnalyticsEvent {
  final UserAnalytics analytics;

  SaveAnalyticsEvent(this.analytics);
}