// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'sql_helper.dart';
import 'db/student_databases.dart';
import 'package:crud_flutter/model/student.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List<Student> students;
  bool isLoading = false;
  int studentCount = 0;

  @override
  void initState() {
    super.initState();

    // dispose();
    
    refreshStudents();
    calculateStudentCount();
  }

  Future insertStudent(Student student) async {
    await StudentDatabase.instance.create(student);
  }

  void calculateStudentCount() async {
    await refreshStudents();
    setState(() {
      studentCount = students.length;
    });
  }

  @override
  void dispose() {
    StudentDatabase.instance.close();
    super.dispose();
  }

  Future refreshStudents() async {
    setState(() => isLoading = true);
    students = await StudentDatabase.instance.readAllStudents();
    setState(() => isLoading = false);
  }


  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List <Map<String, dynamic>> studentList = [];


  
  

  @override
  
  Widget build(BuildContext context) {
    
    for (int i = 0; i < students.length; i++) {
      print(students[i].toJson());
    }
    debugPrint(studentList.toString());
    return Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const[
                Text('Student List'),
                Icon(Icons.delete),
              ],
            ),
          ),
          backgroundColor: Colors.blue,
          
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                width: double.infinity,
                height: 50,
                child: Text("Total Student: $studentCount. Total Subject: 0", style: const TextStyle(fontSize: 16),),
              ),
            ),

            //create list that will be displayed
            (studentCount == 0) ? SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                width: double.infinity,
                height: 500,
                child: const Center(
                  child: Text('List is Empty!'),
                )
              ),
            ) :
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final student = students[index];
                  return Card(
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                      subtitle: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 15),
                          children: [
                            const TextSpan(text: "NIM", style: TextStyle(fontWeight: FontWeight.w700)),
                            TextSpan(text: " ${student.nim}\n" , style: const TextStyle(fontWeight: FontWeight.w400)),
                            const TextSpan(text: "Email", style: TextStyle(fontWeight: FontWeight.w700)),
                            TextSpan(text: " ${student.email}\n", style: const TextStyle(fontWeight: FontWeight.w400)),
                            const TextSpan(text: "Phone", style: TextStyle(fontWeight: FontWeight.w700)),
                            TextSpan(text: " ${student.phone}"  , style: TextStyle(fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              nimController.text = students[index].nim;
                              namaController.text = students[index].name;
                              phoneController.text = students[index].phone;
                              emailController.text = students[index].email;

                              //update
                              //show dialog to update data based on id of student that is clicked
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Update Student'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: nimController,
                                          decoration: const InputDecoration(
                                            hintText: 'NIM',
                                          ),
                                        ),
                                        TextField(
                                          controller: namaController,
                                          decoration: const InputDecoration(
                                            hintText: 'Name',
                                          ),
                                        ),
                                        TextField(
                                          controller: phoneController,
                                          decoration: const InputDecoration(
                                            hintText: 'Phone',
                                          ),
                                        ),
                                        TextField(
                                          controller: emailController,
                                          decoration: const InputDecoration(
                                            hintText: 'Email',
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          //update student
                                          Student student = Student(
                                            id: students[index].id,
                                            nim: nimController.text,
                                            name: namaController.text,
                                            phone: phoneController.text,
                                            email: emailController.text,
                                          );
                                          StudentDatabase.instance.update(student);
                                          refreshStudents();
                                          Navigator.pop(context);
                                          nimController.clear();
                                          namaController.clear();
                                          phoneController.clear();
                                          emailController.clear();
                                        },
                                        child: const Text('Update'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              //delete
                              //show dialog to delete data based on id of student that is clicked
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Student'),
                                    content: const Text('Are you sure you want to delete this student?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          //delete student
                                          StudentDatabase.instance.delete(students[index].id!);
                                          refreshStudents();
                                          calculateStudentCount();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Delete'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: students.length,
              ),
            ),
            // add floating + button on bottom right
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                  child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Add Student'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  controller: nimController,
                                  decoration: const InputDecoration(
                                    labelText: 'NIM',
                                    hintText: 'Enter NIM',
                                  ),
                                ),
                                TextField(
                                  controller: namaController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    hintText: 'Enter Name',
                                  ),
                                ),
                                TextField(
                                  controller: phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone',
                                    hintText: 'Enter Phone',
                                  ),
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'Enter Email',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Student student = Student(
                                  nim: nimController.text,
                                  name: namaController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                );
                                nimController.clear();
                                namaController.clear();
                                phoneController.clear();
                                emailController.clear();
                                insertStudent(student);
                                calculateStudentCount();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.person_add_alt_sharp),
                ),
                )
              ),
            ),
          ]
        )
    );
  }
}