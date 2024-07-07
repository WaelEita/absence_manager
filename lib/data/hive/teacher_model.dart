import 'package:hive/hive.dart';
import 'student_model.dart';

@HiveType(typeId: 0)
class Teacher extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  List<Student> students = [];

  Teacher(this.name);
}
