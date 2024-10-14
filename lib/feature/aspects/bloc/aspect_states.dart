part of 'aspect_bloc.dart';

abstract class LifeAspectState extends Equatable {
  @override
  List<Object> get props => [];
}

class AspectsInitial extends LifeAspectState {}

class AspectsLoading extends LifeAspectState {}

class AspectsLoaded extends LifeAspectState {
  final List<LifeAspect> aspects;
  final List<Task> tasks;
  final User user;

  AspectsLoaded(this.aspects, this.tasks, this.user);

  @override
  List<Object> get props => [aspects, tasks, user];
}

class AspectsError extends LifeAspectState {
  final String error;

  AspectsError(this.error);

  @override
  List<Object> get props => [error];
}

class AnalyticsLoaded extends LifeAspectState {
  final UserAnalytics analytics;

  AnalyticsLoaded(this.analytics);

  @override
  List<Object> get props => [analytics];
}
