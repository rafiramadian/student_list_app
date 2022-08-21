import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_list_app/clients/students_client.dart';
import 'package:student_list_app/screens/home_screen.dart';
import 'package:student_list_app/utils/theme.dart';

import 'blocs/students/students_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final StudentsApiClient studentsApiClient = StudentsApiClient.create();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentsBloc(
        studentsApiClient: studentsApiClient,
      )..add(LoadStudent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student List App',
        theme: ThemeData(
          primaryColor: primaryColor500,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
