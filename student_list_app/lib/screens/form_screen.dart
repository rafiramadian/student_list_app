import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanoid/nanoid.dart';
import 'package:student_list_app/blocs/students/students_bloc.dart';
import 'package:student_list_app/models/student.dart';
import 'package:student_list_app/utils/theme.dart';

// ignore: must_be_immutable
class FormScreen extends StatefulWidget {
  Student? student;

  FormScreen({
    super.key,
    this.student,
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _lastNameController.text = widget.student!.lastName;
      _ageController.text = widget.student!.age.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor500,
        title: Text(
          widget.student != null ? 'Edit Student' : 'Add New Student',
          style: titleTextStyle.copyWith(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFormField(
                controller: _nameController,
                hintText: 'Name',
                isAge: false,
                autofocus: true,
              ),
              const Divider(
                height: 12.0,
              ),
              _buildTextFormField(
                controller: _lastNameController,
                hintText: 'Last Name',
                isAge: false,
                autofocus: false,
              ),
              const Divider(
                height: 12.0,
              ),
              _buildTextFormField(
                controller: _ageController,
                hintText: 'Age',
                isAge: true,
                autofocus: false,
              ),
              const Divider(
                height: 12.0,
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required bool isAge,
    required bool autofocus,
  }) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: subtitleTextStyle.copyWith(
          color: colorBlack.withOpacity(0.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.solid,
          ),
        ),
        errorStyle: subtitleTextStyle.copyWith(
          color: Colors.red.shade800,
          fontSize: 12.0,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red.withOpacity(0.75),
          ),
        ),
        filled: true,
        fillColor: colorWhite,
      ),
      style: subtitleTextStyle.copyWith(color: primaryColor500),
      keyboardType: isAge ? TextInputType.number : TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Form tidak boleh kosong';
        }
        return null;
      },
    );
  }

  _buildSubmitButton() {
    return BlocConsumer<StudentsBloc, StudentsState>(
      listener: (context, state) {
        if (state is StudentsLoaded) {
          Navigator.pop(context);
          _snackBar(
            icon: const Icon(
              Icons.check_circle_outline,
              color: colorWhite,
            ),
            message: widget.student != null ? 'Edit student successfully' : 'Add new student successfully',
            color: Colors.green,
          );
        }
      },
      builder: (context, state) {
        if (state is StudentsError) {
          _snackBar(
            icon: const Icon(
              Icons.error_outline,
              color: colorWhite,
            ),
            message: state.message,
            color: Colors.red,
          );
        }

        return InkWell(
          onTap: () async {
            if (!_formKey.currentState!.validate()) return;

            final student = Student(
              id: widget.student != null ? widget.student!.id : customAlphabet('1234567890', 3),
              name: _nameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              age: int.parse(_ageController.text),
            );

            if (widget.student != null) {
              context.read<StudentsBloc>().add(EditStudent(student));
            } else {
              context.read<StudentsBloc>().add(AddStudent(student));
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            width: state is StudentsLoading ? 80 : MediaQuery.of(context).size.width * 0.5,
            height: 50,
            decoration: BoxDecoration(
              color: primaryColor500,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: state is StudentsLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: colorWhite,
                    ),
                  )
                : Text(
                    'Submit',
                    style: titleTextStyle.copyWith(
                      fontSize: 18.0,
                    ),
                  ),
          ),
        );
      },
    );
  }

  _snackBar({
    required Icon icon,
    required String message,
    required Color color,
  }) {
    return Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              icon,
              const SizedBox(
                width: 8.0,
              ),
              Text(
                message,
                style: subtitleTextStyle.copyWith(fontSize: 14.0),
              ),
            ],
          ),
          backgroundColor: color,
        ),
      );
    });
  }
}
