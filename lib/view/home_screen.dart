import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/hive/hive_helper.dart';
import '../data/hive/teacher_model.dart';
import '../utils/colors.dart';
import 'details_screen.dart';
import 'widgets/add_dialog.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/person_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Box<Teacher>? teacherBox;

  @override
  void initState() {
    super.initState();
    openTeacherBox();
  }

  Future<void> openTeacherBox() async {
    teacherBox = await HiveHelper.openTeacherBox();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'قائمة المعلمين',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: teacherBox == null
              ? const Center(
                  child: CircularProgressIndicator(
                  color: primaryColor,
                ))
              : ValueListenableBuilder<Box<Teacher>>(
                  valueListenable: teacherBox!.listenable(),
                  builder: (context, box, _) {
                    final teachers = box.values.toList();
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: teachers.length,
                      itemBuilder: (context, index) {
                        return PersonCard<Teacher>(
                          person: teachers[index],
                          title: 'أ. ${teachers[index].name}',
                          onRemove: _removeTeacher,
                          onTap: (teacher) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsScreen(teacher: teacher),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (teacherBox != null) {
            _showAddTeacherDialog(context);
          }
        },
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAddTeacherDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddDialog(
          title: 'إضافة معلم جديد',
          hintText: 'اسم المعلم',
          existingNames:
              teacherBox!.values.map((teacher) => teacher.name).toList(),
          onAdded: (newTeacherName) {
            _addTeacher(newTeacherName);
          },
        );
      },
    );
  }

  void _addTeacher(String newTeacherName) {
    if (teacherBox != null && newTeacherName.isNotEmpty) {
      final exists =
          teacherBox!.values.any((teacher) => teacher.name == newTeacherName);
      if (!exists) {
        final newTeacher = Teacher(newTeacherName);
        teacherBox!.add(newTeacher);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('المعلم موجود بالفعل في القائمة!'),
          ),
        );
      }
    }
  }

  void _removeTeacher(Teacher teacher) {
    if (teacherBox != null) {
      for (var student in teacher.students) {
        student.delete();
      }
      teacherBox!.delete(teacher.key);
    }
  }
}
