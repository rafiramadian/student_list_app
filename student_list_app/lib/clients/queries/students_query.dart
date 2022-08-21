const getStudents = '''
query {
  persons {
    id,
    name,
    lastName,
    age
  }
}
''';

const addStudent = r'''
mutation AddPerson($id: ID,$name: String, $lastname: String, $age: Int) {
  addPerson(id: $id, name: $name, lastName: $lastname, age: $age){
    id
    name
    lastName
    age
  }
}
''';

const editStudent = r'''
mutation EditPerson($id: ID,$name: String, $lastname: String, $age: Int) {
  editPerson(id: $id, name: $name, lastName: $lastname, age: $age){
    id
    name
    lastName
    age
  }
}
''';

const deleteStudent = r'''
mutation DeletePerson($id: ID) {
  deletePerson(id: $id){
    id
    name
    lastName
    age
  }
}
''';
