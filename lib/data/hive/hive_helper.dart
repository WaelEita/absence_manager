import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'adapter/student_adapter.dart';
import 'adapter/teacher_adapter.dart';
import 'model/student_model.dart';
import 'model/teacher_model.dart';

class HiveHelper {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    // Register adapters only once
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TeacherAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(StudentAdapter());
    }
  }

  static Future<Box<Teacher>> openTeacherBox() async {
    await initHive();
    return await Hive.openBox<Teacher>('teacherBox');
  }

  static Future<Box<Student>> openStudentBox() async {
    await initHive();
    return await Hive.openBox<Student>('studentBox');
  }
}
