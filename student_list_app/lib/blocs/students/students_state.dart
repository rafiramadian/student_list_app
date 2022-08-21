part of 'students_bloc.dart';

abstract class StudentsState extends Equatable {
  const StudentsState();

  @override
  List<Object> get props => [];
}

class StudentsLoading extends StudentsState {}

class StudentsLoaded extends StudentsState {
  final List<Student> students;

  const StudentsLoaded({required this.students});

  @override
  List<Object> get props => [students];
}

class StudentsError extends StudentsState {
  final String message;

  const StudentsError({required this.message});

  @override
  List<Object> get props => [message];
}
