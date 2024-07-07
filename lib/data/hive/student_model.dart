import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Student extends HiveObject {
  @HiveField(0)
  late String name;

  Student(this.name);
}
