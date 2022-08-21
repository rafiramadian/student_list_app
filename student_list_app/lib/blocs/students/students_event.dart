part of 'students_bloc.dart';

abstract class StudentsEvent extends Equatable {
  const StudentsEvent();

  @override
  List<Object> get props => [];
}

class LoadStudent extends StudentsEvent {}

class RefetchStudent extends StudentsEvent {}

class AddStudent extends StudentsEvent {
  final Student student;

  const AddStudent(this.student);

  @override
  List<Object> get props => [student];
}

class EditStudent extends StudentsEvent {
  final Student student;

  const EditStudent(this.student);

  @override
  List<Object> get props => [student];
}

class DeleteStudent extends StudentsEvent {
  final String id;

  const DeleteStudent(this.id);

  @override
  List<Object> get props => [id];
}
