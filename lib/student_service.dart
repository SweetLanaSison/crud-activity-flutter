import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_model.dart';

class StudentService{
  static const String baseUrl = 'https://crud-activity-node.onrender.com/api/students';

  Future<List<Student>> getStudents() async {
    final response = await http.get(Uri.parse(baseUrl));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      //convert list of JSON objects (from api) to list of dart objects (Student)
      //(student) represent each json object //Student.fromJson(student) is a factory 
      //constructor that creates a Student object from the JSON data. //it takes each 
      //JSON object (representing a student's data) and converts it into a Student Dart object
      return jsonResponse.map((student) => Student.fromJson(student)).toList();
    }
    else{
      throw Exception('Failed to laod students');
    }
  }

  Future<Student> createStudent(Student student) async {
    final response = await http.post(Uri.parse(baseUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(student.toJson()),
    );
    if(response.statusCode == 201){
      return Student.fromJson(json.decode(response.body));
    }
    else{
      print('Failed to create student: ${response.body}'); // Print the server response
      throw Exception('failed to create student');
    }
  }
  
  Future<Student> updateStudent(String id, Student student) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
    if (response.statusCode == 200) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update student');
    }
  }

  Future<void> deleteStudent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete student');
    }
  }
}

