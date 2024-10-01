import 'package:tdd_curso/src/shared/models/task.dart';
import 'package:tdd_curso/src/shared/repositories/board_repository.dart';
import 'package:tdd_curso/src/shared/repositories/isar/isar_datasource.dart.dart';
import 'package:tdd_curso/src/shared/repositories/isar/task_model.dart';

class IsarBoardRepository implements BoardRepository {
  final IsarDatasource datasource;

  IsarBoardRepository(this.datasource);

  @override
  Future<List<Task>> fetch() async {
    final models = await datasource.getTasks();

    return models
        .map((taskModel) => Task(
            id: taskModel.id,
            description: taskModel.description,
            check: taskModel.check))
        .toList();
  }

  @override
  Future<List<Task>> update(List<Task> tasks) async {
    final models = tasks.map((task) {
      final model = TaskModel()
        ..check = task.check
        ..description = task.description;
      if (task.id != -1) {
        model.id = task.id;
      }
      return model;
    }).toList();

    await datasource.deleteAllTasks();
    await datasource.putAllTasks(models);

    return tasks;
  }
}
