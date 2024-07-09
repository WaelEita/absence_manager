import 'package:absence_manager/data/hive/model/student_model.dart';
import 'package:hive/hive.dart';
import '../model/teacher_model.dart';

class TeacherAdapter extends TypeAdapter<Teacher> {
  @override
  final int typeId = 0;

  @override
  Teacher read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    var teacher = Teacher(fields[0] as String);
    teacher.students = (fields[1] as List?)?.cast<Student>() ?? [];
    return teacher;
  }

  @override
  void write(BinaryWriter writer, Teacher obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.students);
  }
}
