import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:student_list_app/clients/queries/queries.dart' as queries;
import 'package:student_list_app/utils/connectivity.dart';

import '../models/student.dart';

class GetStudentsRequestFailure implements Exception {}

class StudentsApiClient {
  const StudentsApiClient({required GraphQLClient graphQLClient}) : _graphQLClient = graphQLClient;

  factory StudentsApiClient.create() {
    final httpLink = HttpLink('https://examplegraphql.herokuapp.com/graphql');
    final link = Link.from([httpLink]);

    return StudentsApiClient(
      graphQLClient: GraphQLClient(cache: GraphQLCache(), link: link),
    );
  }

  final GraphQLClient _graphQLClient;

  Future<List<Student>> getStudents() async {
    if (!await isInternet()) {
      throw 'No connection';
    }

    final result = await _graphQLClient.query(
      QueryOptions(
        document: gql(queries.getStudents),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception.toString();
    debugPrint(result.data!.toString());

    final students = result.data!['persons'] as List;
    final data = students.map((student) => Student.fromMap(student)).toList();
    return data;
  }

  Future<void> addStudent({required Student student}) async {
    if (!await isInternet()) {
      throw 'No connection';
    }

    final result = await _graphQLClient.mutate(
      MutationOptions(
        document: gql(queries.addStudent),
        variables: {"id": student.id, "name": student.name, "lastname": student.lastName, "age": student.age},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception.toString();
    debugPrint(result.data!.toString());
  }

  Future<void> editStudent({required Student student}) async {
    if (!await isInternet()) {
      throw 'No connection';
    }

    final result = await _graphQLClient.mutate(
      MutationOptions(
        document: gql(queries.editStudent),
        variables: {"id": student.id, "name": student.name, "lastname": student.lastName, "age": student.age},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception.toString();
    debugPrint(result.data!.toString());
  }

  Future<void> deleteStudent({required String id}) async {
    if (!await isInternet()) {
      throw 'No connection';
    }

    final result = await _graphQLClient.mutate(
      MutationOptions(
        document: gql(queries.deleteStudent),
        variables: {"id": id},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception.toString();
    debugPrint(result.data!.toString());
  }
}
