import 'package:flutter/material.dart';

import 'adding_employee.dart';
import 'edit_employees.dart';
import 'employee_detail.dart';
import 'my_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  bool isLoading = false;
  List<Employee> employees = List.empty(growable: true);
  final MyDatabase my_database = MyDatabase();
  int count = 0;

  // getData from firebase
  getDataFromDb() async {
    //
    await my_database.initializeDatabase();
    List<Map<String, Object?>> map = await my_database.getEmpList();
    for (int i = 0; i < map.length; i++) {
      //
      employees.add(Employee.toEmp(map[i]));
      //
    }
    count = await my_database.countEmp();
    setState(() {
      isLoading = false;
    });
    //
  }

  @override
  void initState() {
    // employees.add(Employee(
    //     empId: 11, empName: 'abc', empDesignation: 'xyz', isMale: true));
    // employees.add(Employee(
    //     empId: 11, empName: 'xyas', empDesignation: 'ere', isMale: false));
    getDataFromDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees ($count)'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : employees.isEmpty
          ? const Center(
        child: Text('No Employee yet'),
      )
          : ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditEmployee(
                      employee: employees[index],
                      myDatabase: my_database,
                    ),
                  ));
            },
            leading: CircleAvatar(
              backgroundColor:
              employees[index].isMale ? Colors.blue : Colors.pink,
              child: Icon(
                employees[index].isMale ? Icons.male : Icons.female,
                color: Colors.white,
              ),
            ),
            title: Text(
              '${employees[index].empName} (${employees[index].empId})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(employees[index].empDesignation),
            trailing: IconButton(
                onPressed: () async {
                  //
                  String empName = employees[index].empName;
                  await my_database.deleteEmp(employees[index]);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('$empName deleted.')));
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                            (route) => false);
                  }
                  //
                },
                icon: const Icon(Icons.delete)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            //
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddingEmployee(myDatabase: my_database),
                ));
            //
          }),
    );
  }
//
//
}
