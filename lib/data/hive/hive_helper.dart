import 'package:absence_manager/data/hive/adapter/student_adapter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'model/teacher_model.dart';
import 'adapter/teacher_adapter.dart';
import 'model/student_model.dart';

class HiveHelper {
  static bool _isInitialized = false;

  static Future<void> initHive() async {
    if (!_isInitialized) {
      final appDocumentDir =
      await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
      Hive.registerAdapter(TeacherAdapter());
      Hive.registerAdapter(StudentAdapter());
      _isInitialized = true;
    }
  }

  static Future<Box<Teacher>> openTeacherBox() async {
    await initHive();
    return await Hive.openBox<Teacher>('teachers');
  }

  static Future<Box<Student>> openStudentBox() async {
    await initHive();
    return await Hive.openBox<Student>('students');
  }
}
