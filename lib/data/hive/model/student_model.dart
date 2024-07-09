import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Student extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  int absences = 0;

  Student(this.name);
}
