import 'package:flutter/material.dart';
import 'student_service.dart';
import 'student_model.dart';
import 'student_detail_screen.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Student>> futureStudents;

  @override
  void initState() {
    super.initState();
    futureStudents = StudentService().getStudents();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
      ),
      body: FutureBuilder<List<Student>>(
        future: futureStudents,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return Center(child: Text('No students found.'));
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final student = snapshot.data![index];
                return ListTile(
                  title: Text('${student.firstName} ${student.lastName}'),
                  subtitle: Text('${student.course} - ${student.year}'),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentDetailScreen(student: student),
                      ),
                    );

                    // Check if result not null, meaning this is edited
                    if (result == true) {
                      setState(() {
                        futureStudents = StudentService().getStudents(); // Refresh the list
                      });
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDetailScreen(),
            ),
          );

          if (result == true) { // A student was changed (add or edit)
            setState(() {
              futureStudents = StudentService().getStudents(); // Refresh the list
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
