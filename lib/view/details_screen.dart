import 'package:absence_manager/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/hive/hive_helper.dart';
import '../data/hive/student_model.dart';
import '../data/hive/teacher_model.dart';
import '../utils/colors.dart';
import 'widgets/add_dialog.dart';
import 'widgets/person_card.dart';

class DetailsScreen extends StatefulWidget {
  final Teacher teacher;

  const DetailsScreen({super.key, required this.teacher});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Box<Teacher>? teacherBox;
  Box<Student>? studentBox;

  @override
  void initState() {
    super.initState();
    openBoxes();
  }

  Future<void> openBoxes() async {
    teacherBox = await HiveHelper.openTeacherBox();
    studentBox = await HiveHelper.openStudentBox();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'تفاصيل المعلم',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: teacherBox == null || studentBox == null
              ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ))
              : ValueListenableBuilder<Box<Teacher>>(
            valueListenable: teacherBox!.listenable(),
            builder: (context, box, _) {
              final teacher = box.get(widget.teacher.key);
              final students = teacher?.students ?? [];
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return PersonCard<Student>(
                    person: students[index],
                    title: students[index].name,
                    onRemove: _removeStudent,
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddStudentDialog(context);
        },
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddDialog(
          title: 'إضافة طالب جديد',
          hintText: 'اسم الطالب',
          existingNames:
          widget.teacher.students.map((student) => student.name).toList(),
          onAdded: (newStudentName) {
            _addStudent(newStudentName);
          },
        );
      },
    );
  }

  void _addStudent(String newStudentName) {
    if (teacherBox != null && newStudentName.isNotEmpty) {
      final teacher = teacherBox!.get(widget.teacher.key);
      if (teacher != null) {
        final exists =
        teacher.students.any((student) => student.name == newStudentName);
        if (!exists) {
          final newStudent = Student(newStudentName);
          studentBox!.add(newStudent); // Add student to the student box
          teacher.students.add(newStudent);
          teacher.save();
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('الطالب موجود بالفعل في القائمة!'),
            ),
          );
        }
      }
    }
  }

  void _removeStudent(Student student) {
    if (teacherBox != null && studentBox != null) {
      final teacher = teacherBox!.get(widget.teacher.key);
      if (teacher != null) {
        teacher.students.remove(student);
        teacher.save();
        studentBox!.delete(student.key);
        setState(() {});
      }
    }
  }
}
