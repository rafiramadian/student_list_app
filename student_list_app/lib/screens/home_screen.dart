import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:student_list_app/blocs/students/students_bloc.dart';
import 'package:student_list_app/screens/form_screen.dart';
import 'package:student_list_app/utils/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor500,
        title: Text(
          'Student List',
          style: titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<StudentsBloc>().add(RefetchStudent());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          if (state is StudentsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StudentsLoaded) {
            final students = state.students;
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemCount: students.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    extentRatio: 0.5,
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FormScreen(
                                student: students[index],
                              ),
                            ),
                          );
                        },
                        backgroundColor: Colors.yellow.shade600,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          context.read<StudentsBloc>().add(DeleteStudent(students[index].id));
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    leading: CircleAvatar(
                      backgroundColor: primaryColor500,
                      child: Text(
                        students[index].name == "" ? '?' : students[index].name.substring(0, 1).toUpperCase(),
                        style: subtitleTextStyle,
                      ),
                    ),
                    title: Text(
                      '${students[index].name} ${students[index].lastName}',
                      style: titleTextStyle.copyWith(
                        color: colorBlack,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      students[index].age.toString(),
                      style: subtitleTextStyle.copyWith(color: colorBlack),
                    ),
                  ),
                );
              },
            );
          } else if (state is StudentsError) {
            return Center(
              child: Text(
                state.message,
                style: subtitleTextStyle.copyWith(color: colorBlack),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
