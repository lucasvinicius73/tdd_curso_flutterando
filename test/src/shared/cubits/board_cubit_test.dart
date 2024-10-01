import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_curso/src/shared/cubits/board_cubit.dart';
import 'package:tdd_curso/src/shared/models/task.dart';
import 'package:tdd_curso/src/shared/repositories/board_repository.dart';
import 'package:tdd_curso/src/states/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository;
  late BoardCubit cubit;

  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  group("fetchTasks |", () {
    test("Get All Tasks", () async {
      when(() => repository.fetch()).thenAnswer((_) async => [
            const Task(id: 1, description: "", check: false),
          ]);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<LoadingBoardingState>(),
            isA<GettedTaskBoardState>(),
          ]));
      await cubit.fetchTasks();
    });

    test("Get All Tasks Error", () async {
      when(() => repository.fetch()).thenThrow(Exception("Error"));

      expect(
          cubit.stream,
          emitsInOrder([
            isA<LoadingBoardingState>(),
            isA<FailureBoardState>(),
          ]));

      await cubit.fetchTasks();
    });
  });

  group("AddTask |", () {
    test("Add All Tasks", () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTaskBoardState>(),
          ]));
      const task = Task(id: 1, description: "description");

      await cubit.addTask(task);
      final state = cubit.state as GettedTaskBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks, [task]);
    });

    test("Add All Tasks Error", () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));

      expect(
          cubit.stream,
          emitsInOrder(
            [isA<FailureBoardState>()],
          ));
      const task = Task(id: 1, description: "description");
      await cubit.addTask(task);
    });
  });
  group("Remove Task |", () {
    test("Remove one task", () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);
      const task = Task(id: 1, description: "description");
      cubit.addTasks([task]);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTaskBoardState>(),
          ]));

      await cubit.removeTask(task);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 0);
    });

    test("Remove one task Error", () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));
      const task = Task(id: 1, description: "description");
      cubit.addTasks([task]);
      expect(
          cubit.stream,
          emitsInOrder(
            [isA<FailureBoardState>()],
          ));

      await cubit.removeTask(task);
    });
  });
  group("CheckTask |", () {
    test("Check one task", () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);
      const task = Task(id: 1, description: "description");
      cubit.addTasks([task]);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);
      expect((cubit.state as GettedTaskBoardState).tasks.first.check, false);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTaskBoardState>(),
          ]));

      await cubit.checkTask(task);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);
      expect((cubit.state as GettedTaskBoardState).tasks.first.check, true);
    });

    test("Check one task Error", () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));
      const task = Task(id: 1, description: "description");
      cubit.addTasks([task]);
      expect(
          cubit.stream,
          emitsInOrder(
            [isA<FailureBoardState>()],
          ));

      await cubit.checkTask(task);
    });
  });
}
