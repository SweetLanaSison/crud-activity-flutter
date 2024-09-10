import 'package:flutter/material.dart';
import 'student_model.dart';
import 'student_service.dart';

class StudentDetailScreen extends StatefulWidget {
  final Student? student;

  StudentDetailScreen({this.student});
  
  @override
  _StudentDetailScreenState createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  String course = 'Science';
  String year = 'First Year';
  bool enrolled = false;

   @override
  void initState() {
    super.initState();
    if(widget.student != null){ //when editing student
      firstName = widget.student!.firstName;
      lastName = widget.student!.lastName;
      course = widget.student!.course;
      year = widget.student!.year;
      enrolled = widget.student!.enrolled;
    }
    else{ //when creating student
      firstName = '';
      lastName = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
        actions: widget.student != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await StudentService().deleteStudent(widget.student!.id);
                    Navigator.pop(context, true);
                  },
                ),
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: firstName,
                decoration: InputDecoration(labelText: 'Firs Name'),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please eneter first name';
                  }
                  return null;
                },
                onSaved: (value){
                  firstName = value!;
                },
              ),
              TextFormField(
                initialValue: lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  lastName = value!;
                },
              ),
              DropdownButtonFormField<String>(
                value: course, //curently selected value from dropdown, by default
                decoration: InputDecoration(labelText: 'Course'), //text when not selected yet
                items: ['Science', 'Commerce', 'Arts'].map((String value){ //iterate thru value in list and converts to ...
                  return DropdownMenuItem<String>( //representing each item
                    value: value, //set when user select item
                    child: Text(value),
                    );
                }).toList(), //converts the iterable returned by map to list
                onChanged: (newValue){ //used when user select new value
                  setState(() {
                    course = newValue!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: year,
                decoration: InputDecoration(labelText: 'Year'),
                items: [
                  'First Year',
                  'Second Year',
                  'Third Year',
                  'Fourth Year',
                  'Fifth Year'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    year = newValue!;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Enrolled'),
                value: enrolled,
                onChanged: (bool newValue) {
                  setState(() {
                    enrolled = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if(widget.student == null){ //no student yet
                      //create student
                      await StudentService().createStudent(Student(
                        id: '',
                        firstName: firstName,
                        lastName: lastName,
                        course: course,
                        year: year,
                        enrolled: enrolled,
                      ));
                    }
                    else{
                      //update student
                      await StudentService().updateStudent(
                        widget.student!.id,
                        Student(
                          id: widget.student!.id,
                          firstName: firstName,
                          lastName: lastName,
                          course: course,
                          year: year,
                          enrolled: enrolled,
                        ),
                      );
                    }
                    Navigator.pop(context, true); //true meaning edited
                  }
                },
                child: Text(widget.student == null ? 'Add' : 'Update'),
              ),
            ],),
        ),),
    );
  }
}