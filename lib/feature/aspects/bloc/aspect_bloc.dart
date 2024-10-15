import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plinko/core/dependency_injection.dart';
import 'package:plinko/core/utils/log.dart';
import 'package:plinko/feature/aspects/models/life_aspect.dart';
import 'package:plinko/feature/aspects/models/task.dart';
import 'package:plinko/feature/aspects/models/user.dart';
import 'package:plinko/feature/analytics/models/user_analytics.dart';
import 'package:plinko/feature/aspects/repository/life_aspect_repository.dart';
import 'package:plinko/feature/aspects/repository/user_data_repository.dart';
import 'package:uuid/uuid.dart';

part 'aspect_events.dart';
part 'aspect_states.dart';

class LifeAspectBloc extends Bloc<LifeAspectEvent, LifeAspectState> {
  final LifeAspectRepository aspectRepository = locator<LifeAspectRepository>();
  final UserDataRepository userRepository = locator<UserDataRepository>();

  LifeAspectBloc() : super(AspectsInitial()) {
    on<LoadAspects>(_onLoadAspects);
    on<AddAspect>(_onAddAspect);
    on<RemoveAspect>(_onRemoveAspect);
    on<AddTask>(_onAddTask);
    on<PlanTaskForWeek>(_onPlanTaskForWeek);
    on<MarkTaskAsCompleted>(_onMarkTaskAsCompleted);
    on<AddCompletedTaskForToday>(_onAddCompletedTaskForToday);
    on<GenerateAnalytics>(_onGenerateAnalytics);
    on<RemoveOverdueTask>(_onRemoveOverdueTask);
    on<AddCompletedTaskFromOverdue>(_onAddCompletedTaskFromOverdue);
    on<DeleteCompletedTask>(_onDeleteCompletedTask);
    on<DeletePlannedTask>(_onDeletePlannedTask);
  }

  Future<void> _onLoadAspects(
    LoadAspects event,
    Emitter<LifeAspectState> emit,
  ) async {
    emit(AspectsLoading());
    try {
      final aspects = await aspectRepository.getAspects();
      final tasks = await aspectRepository.getTasks();
      final user = await userRepository.getUser() ??
          User(
            name: 'User',
            completedTasksToday: const [],
            plannedTasksForWeek: const {},
            expectedScores: const {},
            overdueTasks: const {},
          );
      emit(AspectsLoaded(aspects, tasks, user));
    } catch (e) {
      logger.e(e);
      emit(AspectsError("Ошибка загрузки данных"));
    }
  }

  Future<void> _onAddAspect(
    AddAspect event,
    Emitter<LifeAspectState> emit,
  ) async {
    if (state is AspectsLoaded) {
      final currentState = state as AspectsLoaded;
      final updatedAspects = List<LifeAspect>.from(currentState.aspects)
        ..add(event.aspect);
      await aspectRepository.saveAspects(updatedAspects);
      _emitUpdatedState(
        emit,
        updatedAspects,
        currentState.tasks,
        currentState.user,
      );
    }
  }

  Future<void> _onRemoveAspect(
    RemoveAspect event,
    Emitter<LifeAspectState> emit,
  ) async {
    if (state is AspectsLoaded) {
      final currentState = state as AspectsLoaded;
      final updatedAspects = List<LifeAspect>.from(currentState.aspects)
        ..removeWhere((aspect) => aspect.name == event.aspect.name);
      await aspectRepository.saveAspects(updatedAspects);
      _emitUpdatedState(
        emit,
        updatedAspects,
        currentState.tasks,
        currentState.user,
      );
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<LifeAspectState> emit) async {
    if (state is AspectsLoaded) {
      final currentState = state as AspectsLoaded;
      final updatedTasks = List<Task>.from(currentState.tasks)..add(event.task);
      await aspectRepository.saveTasks(updatedTasks);
      _emitUpdatedState(
        emit,
        currentState.aspects,
        updatedTasks,
        currentState.user,
      );
    }
  }

  Future<void> _onPlanTaskForWeek(
    PlanTaskForWeek event,
    Emitter<LifeAspectState> emit,
  ) async {
    if (state is AspectsLoaded) {
      final currentState = state as AspectsLoaded;

      final Map<LifeAspect, double> expectedScores = {
        ...currentState.user.expectedScores,
      };

      event.task.aspectScores.forEach((aspectName, score) {
        final aspect = currentState.aspects.firstWhere(
          (a) => a.name == aspectName,
          orElse: () => LifeAspect(
            name: 'Unknown',
            optimalScore: 0,
            currentScore: 0,
          ),
        );
        expectedScores[aspect] = (expectedScores[aspect] ?? 0) + score;
      });

      final updatedUser = currentState.user.copyWith(
        plannedTasksForWeek: {
          ...currentState.user.plannedTasksForWeek,
          event.day: [
            ...currentState.user.plannedTasksForWeek[event.day] ?? [],
            IdentifiedTask(id: const Uuid().v4(), task: event.task),
          ],
        },
        expectedScores: expectedScores,
      );

      await userRepository.saveUser(updatedUser);
      _emitUpdatedState(
        emit,
        currentState.aspects,
        currentState.tasks,
        updatedUser,
      );
    }
  }

  Future<void> _onMarkTaskAsCompleted(
    MarkTaskAsCompleted event,
    Emitter<LifeAspectState> emit,
  ) async {
    if (state is AspectsLoaded) {
      final currentState = state as AspectsLoaded;

      final updatedPlannedTasksForWeek = Map<String, List<IdentifiedTask>>.from(
        currentState.user.plannedTasksForWeek,
      );
      updatedPlannedTasksForWeek.forEach((day, tasks) {
        tasks.removeWhere((t) => t.id == event.task.id);
      });

      final updatedUser = currentState.user.copyWith(
        completedTasksToday: [
          ...currentState.user.completedTasksToday,
          event.task,
        ],
        plannedTasksForWeek: updatedPlannedTasksForWeek,
      );

      await userRepository.saveUser(updatedUser);
      _emitUpdatedState(
        emit,
        currentState.aspects,
        currentState.tasks,
        updatedUser,
      );
    }
  }

  Future<void> _onAddCompletedTaskForToday(
    AddCompletedTaskForToday event,
    Emitter<LifeAspectState> emit,
  ) async {
    if (state is AspectsLoaded) {
      final currentState = state as AspectsLoaded;
      final task = IdentifiedTask(
        id: const Uuid().v4(),
        task: event.task,
      );
      final updatedUser = currentState.user.copyWith(
        completedTasksToday: [...currentState.user.completedTasksToday, task],
      );

      await userRepository.saveUser(updatedUser);
      await userRepository.addCompletedTaskForToday(task);
      _emitUpdatedState(
        emit,
        currentState.aspects,
        currentState.tasks,
        updatedUser,
      );
    }
  }

  Future<void> _onRemoveOverdueTask(
    RemoveOverdueTask event,
    Emitter<LifeAspectState> emit,
  ) async {
    if (state is AspectsLoaded) {
      final currentState = state as AspectsLoaded;

      if (currentState.user.overdueTasks.containsKey(event.day)) {
        currentState.user.overdueTasks[event.day]
            ?.removeWhere((t) => t.id == event.task.id);

        if (currentState.user.overdueTasks[event.day]?.isEmpty ?? false) {
          currentState.user.overdueTasks.remove(event.day);
        }

        await userRepository.saveUser(currentState.user);
        _emitUpdatedState(
          emit,
          currentState.aspects,
          currentState.tasks,
          currentState.user,
        );
      }
    }
  }

  Future<void> _onAddCompletedTaskFromOverdue(
    AddCompletedTaskFromOverdue event,
    Emitter<LifeAspectState> emit,
  ) async {
    if (state is AspectsLoaded) {
      final currentState = state as AspectsLoaded;

      if (currentState.user.overdueTasks.containsKey(event.day)) {
        final taskToAdd = event.task;

        await _onAddCompletedTaskForToday(
          AddCompletedTaskForToday(taskToAdd.task),
          emit,
        );

        await _onRemoveOverdueTask(
          RemoveOverdueTask(day: event.day, task: taskToAdd),
          emit,
        );
      }
    }
  }

  Future<void> _onGenerateAnalytics(
    GenerateAnalytics event,
    Emitter<LifeAspectState> emit,
  ) async {
    if (state is AspectsLoaded) {
      final currentState = state as AspectsLoaded;

      final aspectScores = currentState.aspects.asMap().map((index, aspect) {
        return MapEntry(aspect.name, aspect.currentScore);
      });
      final totalTasksCompleted = currentState.user.completedTasksToday.length;
      final totalTasksPlanned =
          currentState.user.plannedTasksForWeek.values.expand((x) => x).length;

      final analytics = UserAnalytics(
        aspectScores: aspectScores,
        totalTasksCompleted: totalTasksCompleted,
        totalTasksPlanned: totalTasksPlanned,
      );

      await userRepository.saveUserAnalytics(analytics);
      emit(AnalyticsLoaded(analytics));
    }
  }

  Future<void> _onDeleteCompletedTask(
    DeleteCompletedTask event,
    Emitter<LifeAspectState> emit,
  ) async {
    if (state is AspectsLoaded) {
      final currentState = state as AspectsLoaded;

      currentState.user.completedTasksToday
          .removeWhere((t) => t.id == event.task.id);

      await userRepository.saveUser(currentState.user);

      _emitUpdatedState(
        emit,
        currentState.aspects,
        currentState.tasks,
        currentState.user,
      );
    }
  }

  Future<void> _onDeletePlannedTask(
    DeletePlannedTask event,
    Emitter<LifeAspectState> emit,
  ) async {
    if (state is AspectsLoaded) {
      final currentState = state as AspectsLoaded;
      final updatedPlannedTasksForWeek = Map<String, List<IdentifiedTask>>.from(
        currentState.user.plannedTasksForWeek,
      );
      updatedPlannedTasksForWeek.forEach((day, tasks) {
        tasks.removeWhere((t) => t.id == event.task.id);
      });
      final updatedUser = currentState.user.copyWith(
        plannedTasksForWeek: updatedPlannedTasksForWeek,
      );
      await userRepository.saveUser(updatedUser);
      _emitUpdatedState(
        emit,
        currentState.aspects,
        currentState.tasks,
        updatedUser,
      );
    }
  }

  void _emitUpdatedState(
    Emitter<LifeAspectState> emit,
    List<LifeAspect> aspects,
    List<Task> tasks,
    User user,
  ) {
    emit(AspectsLoaded(aspects, tasks, user));
  }
}
