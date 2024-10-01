import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_curso/src/shared/models/task.dart';
import 'package:tdd_curso/src/shared/repositories/board_repository.dart';
import 'package:tdd_curso/src/shared/repositories/isar/isar_board_repository.dart';
import 'package:tdd_curso/src/shared/repositories/isar/isar_datasource.dart.dart';
import 'package:tdd_curso/src/shared/repositories/isar/task_model.dart';

class IsarDatasourceMock extends Mock implements IsarDatasource {}

void main() {
  late IsarDatasource datasource;
  late BoardRepository repository;

  setUp(() {
    datasource = IsarDatasourceMock();
    repository = IsarBoardRepository(datasource);
  });

  group("Board Repository", () {
    test("fetch", () async {
      when(() => datasource.getTasks())
          .thenAnswer((_) async => [TaskModel()..id = 1]);
      final tasks = await repository.fetch();

      expect(tasks.length, 1);
    });
    test("update", () async {
      when(() => datasource.deleteAllTasks()).thenAnswer((_) async => []);
      when(() => datasource.putAllTasks(any())).thenAnswer((_) async => []);
      final tasks = await repository.update([
        const Task(id: -1, description: 'description'),
        const Task(id: 1, description: 'description')
      ]);

      expect(tasks.length, 2);
    });
  });
}
