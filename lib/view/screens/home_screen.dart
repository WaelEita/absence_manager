import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/hive/hive_helper.dart';
import '../../data/hive/model/teacher_model.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../widgets/add_dialog.dart';
import '../widgets/person_card.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Box<Teacher>? teacherBox;
  bool isSelectionMode = false;
  Set<Teacher> selectedTeachers = {};

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
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 26),
            child: Text(
              isSelectionMode ? 'تحديد عناصر' : 'قائمة المعلمين',
              textAlign: TextAlign.center,
              style: title20.copyWith(color: Colors.white),
            ),
          ),
        ),
        backgroundColor: primaryColor,
        actions: isSelectionMode
            ? [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              _showRemoveConfirmationDialog(context);
            },
          ),
        ]
            : [],
        leading: isSelectionMode
            ? IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            setState(() {
              isSelectionMode = false;
              selectedTeachers.clear();
            });
          },
        )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: teacherBox == null
              ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
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
                    isSelected: selectedTeachers.contains(teachers[index]),
                    onTap: (teacher) {
                      if (isSelectionMode) {
                        _toggleSelection(teacher);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(teacher: teacher),
                          ),
                        );
                      }
                    },
                    onLongPress: () {
                      setState(() {
                        isSelectionMode = true;
                        _toggleSelection(teachers[index]);
                      });
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

  void _toggleSelection(Teacher teacher) {
    setState(() {
      if (selectedTeachers.contains(teacher)) {
        selectedTeachers.remove(teacher);
      } else {
        selectedTeachers.add(teacher);
      }
    });
  }

  void _showRemoveConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: const Text(
            'تأكيد الحذف',
            textAlign: TextAlign.right,
          ),
          content: const Text(
            'هل أنت متأكد أنك تريد حذف العناصر المحددة؟',
            textAlign: TextAlign.right,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: regularText18.copyWith(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                _removeSelectedTeachers();
                Navigator.of(context).pop();
              },
              child: Text(
                'تأكيد',
                style: regularText18.copyWith(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _removeSelectedTeachers() {
    if (teacherBox != null) {
      for (var teacher in selectedTeachers) {
        for (var student in teacher.students) {
          student.delete();
        }
        teacherBox!.delete(teacher.key);
      }
      setState(() {
        selectedTeachers.clear();
        isSelectionMode = false;
      });
    }
  }

  void _showAddTeacherDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddDialog(
          title: 'إضافة معلم جديد',
          hintText: 'اسم المعلم',
          existingNames: teacherBox!.values.map((teacher) => teacher.name).toList(),
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
}
