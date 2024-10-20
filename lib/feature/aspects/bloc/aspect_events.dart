part of 'aspect_bloc.dart';

abstract class LifeAspectEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadAspects extends LifeAspectEvent {}

class AddAspect extends LifeAspectEvent {
  final LifeAspect aspect;
  AddAspect(this.aspect);

  @override
  List<Object> get props => [aspect];
}

class RemoveAspect extends LifeAspectEvent {
  final LifeAspect aspect;
  RemoveAspect(this.aspect);

  @override
  List<Object> get props => [aspect];
}

class AddTask extends LifeAspectEvent {
  final Task task;
  AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class PlanTaskForWeek extends LifeAspectEvent {
  final Task task;
  final String day;
  PlanTaskForWeek(this.task, this.day);

  @override
  List<Object> get props => [task, day];
}

class MarkTaskAsCompleted extends LifeAspectEvent {
  final IdentifiedTask task;
    final String day;
  MarkTaskAsCompleted(this.task, this.day);

  @override
  List<Object> get props => [task, day];
}

class GenerateAnalytics extends LifeAspectEvent {}

class AddCompletedTaskForToday extends LifeAspectEvent {
  final Task task;
    final String day;

  AddCompletedTaskForToday(this.task, this.day);

  @override
  List<Object> get props => [task, day];
}

class RemoveOverdueTask extends LifeAspectEvent {
  final String day;
  final IdentifiedTask task;

  RemoveOverdueTask({required this.day, required this.task});

  @override
  List<Object> get props => [day, task];
}

class AddCompletedTaskFromOverdue extends LifeAspectEvent {
  final String day;
  final IdentifiedTask task;

  AddCompletedTaskFromOverdue({required this.day, required this.task});

  @override
  List<Object> get props => [day, task];
}

class DeleteCompletedTask extends LifeAspectEvent {
  final String day;
  final IdentifiedTask task;

  DeleteCompletedTask({required this.day, required this.task});

  @override
  List<Object> get props => [day, task];
}

class DeletePlannedTask extends LifeAspectEvent {
  final String day;
  final IdentifiedTask task;

  DeletePlannedTask({required this.day, required this.task});

  @override
  List<Object> get props => [day, task];
}
