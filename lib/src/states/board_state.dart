import 'package:tdd_curso/src/shared/models/task.dart';

sealed class BoardState {}

class LoadingBoardingState implements BoardState {}

class GettedTaskBoardState implements BoardState {
  final List<Task> tasks;

  GettedTaskBoardState({required this.tasks});
}

class EmptyBoardState extends GettedTaskBoardState {
  EmptyBoardState() : super(tasks: []);
}

class FailureBoardState implements BoardState {
  final String message;
  FailureBoardState({required this.message});
}
