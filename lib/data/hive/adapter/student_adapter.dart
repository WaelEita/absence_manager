import 'package:absence_manager/data/hive/model/student_model.dart';
import 'package:hive/hive.dart';

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 1;

  @override
  Student read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }
}
