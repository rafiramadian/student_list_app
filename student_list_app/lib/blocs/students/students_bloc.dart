import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_list_app/clients/students_client.dart';
import 'package:student_list_app/models/student.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  StudentsBloc({required StudentsApiClient studentsApiClient})
      : _studentsApiClient = studentsApiClient,
        super(StudentsLoading()) {
    on<LoadStudent>(_loadStudent);
    on<RefetchStudent>(_refetchStudent);
    on<AddStudent>(_addStudent);
    on<EditStudent>(_editStudent);
    on<DeleteStudent>(_deleteStudent);
  }

  final StudentsApiClient _studentsApiClient;

  void _loadStudent(LoadStudent event, Emitter<StudentsState> emit) async {
    try {
      emit(StudentsLoading());
      final students = await _studentsApiClient.getStudents();
      emit(StudentsLoaded(students: students));
    } catch (e) {
      emit(StudentsError(message: e.toString()));
    }
  }

  void _refetchStudent(RefetchStudent event, Emitter<StudentsState> emit) async {
    try {
      emit(StudentsLoading());
      final students = await _studentsApiClient.getStudents();
      emit(StudentsLoaded(students: students));
    } catch (e) {
      emit(StudentsError(message: e.toString()));
    }
  }

  void _addStudent(AddStudent event, Emitter<StudentsState> emit) async {
    try {
      emit(StudentsLoading());
      await _studentsApiClient.addStudent(student: event.student);
      final students = await _studentsApiClient.getStudents();
      emit(StudentsLoaded(students: students));
    } catch (e) {
      emit(StudentsError(message: e.toString()));
    }
  }

  void _editStudent(EditStudent event, Emitter<StudentsState> emit) async {
    try {
      emit(StudentsLoading());
      await _studentsApiClient.editStudent(student: event.student);
      final students = await _studentsApiClient.getStudents();
      emit(StudentsLoaded(students: students));
    } catch (e) {
      emit(StudentsError(message: e.toString()));
    }
  }

  void _deleteStudent(DeleteStudent event, Emitter<StudentsState> emit) async {
    try {
      emit(StudentsLoading());
      await _studentsApiClient.deleteStudent(id: event.id);
      final students = await _studentsApiClient.getStudents();
      emit(StudentsLoaded(students: students));
    } catch (e) {
      emit(StudentsError(message: e.toString()));
    }
  }
}
