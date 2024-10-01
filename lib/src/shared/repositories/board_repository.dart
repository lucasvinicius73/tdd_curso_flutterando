import 'package:tdd_curso/src/shared/models/task.dart';

abstract class BoardRepository {
  Future<List<Task>> fetch();
  Future<List<Task>> update(List<Task> tasks);
}
