import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tdd_curso/src/shared/models/task.dart';
import 'package:tdd_curso/src/shared/repositories/board_repository.dart';
import 'package:tdd_curso/src/states/board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;

  BoardCubit(this.repository) : super(EmptyBoardState());

  Future<void> fetchTasks() async {
    emit(LoadingBoardingState());

    try {
      final tasks = await repository.fetch();
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: "Erro: $e"));
    }
  }

  Future<void> addTask(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.add(newTask);
    emitTasks(tasks);
  }

  Future<void> removeTask(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.remove(newTask);

    emitTasks(tasks);
  }

  Future<void> checkTask(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    final index = tasks.indexOf(newTask);
    tasks[index] = newTask.copyWith(check: !newTask.check);
    emitTasks(tasks);
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTaskBoardState(tasks: tasks));
  }

  List<Task>? _getTasks() {
    final state = this.state;
    if (state is! GettedTaskBoardState) {
      return null;
    }
    return state.tasks.toList();
  }

  Future<void> emitTasks(List<Task> tasks) async {
    try {
      await repository.update(tasks);
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: "Error"));
    }
  }
}
