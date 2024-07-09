import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/hive/hive_helper.dart';
import '../../data/hive/model/student_model.dart';
import '../../data/hive/model/teacher_model.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../widgets/add_dialog.dart';
import '../widgets/person_card.dart';

class DetailsScreen extends StatefulWidget {
  final Teacher teacher;

  const DetailsScreen({super.key, required this.teacher});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Box<Teacher>? teacherBox;
  Box<Student>? studentBox;
  bool isSelectionMode = false;
  Set<Student> selectedStudents = {};
  bool showCounter = false;

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
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 26),
            child: Text(
              isSelectionMode ? 'تحديد عناصر' : 'تفاصيل المعلم',
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
                    selectedStudents.clear();
                  });
                },
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: teacherBox == null || studentBox == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
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
                          counter: students[index].absences,
                          // Show counter for students
                          onRemove: _removeStudent,
                          isSelected:
                              selectedStudents.contains(students[index]),
                          onIncrement: () => _increaseAbsence(students[index]),
                          onDecrement: () => _decreaseAbsence(students[index]),
                          onTap: (student) {
                            if (isSelectionMode) {
                              _toggleSelection(student);
                            } else {
                              // handle normal tap behavior
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              isSelectionMode = true;
                              _toggleSelection(students[index]);
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

  void _toggleSelection(Student student) {
    setState(() {
      if (selectedStudents.contains(student)) {
        selectedStudents.remove(student);
      } else {
        selectedStudents.add(student);
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
              child: Text('إلغاء',
                  style: regularText18.copyWith(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _removeSelectedStudents();
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

  void _removeSelectedStudents() {
    if (teacherBox != null && studentBox != null) {
      final teacher = teacherBox!.get(widget.teacher.key);
      if (teacher != null) {
        for (var student in selectedStudents) {
          teacher.students.remove(student);
          studentBox!.delete(student.key);
        }
        teacher.save();
        setState(() {
          selectedStudents.clear();
          isSelectionMode = false;
        });
      }
    }
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
          studentBox!.add(newStudent);
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
        studentBox!.delete(student.key);
        teacher.save();
        setState(() {});
      }
    }
  }

  void _increaseAbsence(Student student) {
    setState(() {
      if (studentBox != null && studentBox!.isOpen) {
        final savedStudent = studentBox!.get(student.key);
        if (savedStudent != null) {
          savedStudent.absences += 1;
          savedStudent.save();
        } else {
          debugPrint('Student not found in box: ${student.key}');
        }
      } else {
        debugPrint('Student box is not initialized or closed');
      }
    });
  }

  void _decreaseAbsence(Student student) {
    setState(() {
      if (studentBox != null && studentBox!.isOpen) {
        final savedStudent = studentBox!.get(student.key);
        if (savedStudent != null && savedStudent.absences > 0) {
          savedStudent.absences -= 1;
          savedStudent.save();
        } else {
          debugPrint(
              'Student not found in box or absences <= 0: ${student.key}');
        }
      } else {
        debugPrint('Student box is not initialized or closed');
      }
    });
  }
}
