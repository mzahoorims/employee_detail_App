import 'package:flutter/material.dart';

import 'employee_detail.dart';
import 'home.dart';
import 'my_database.dart';


class AddingEmployee extends StatefulWidget {
  final MyDatabase myDatabase;
  const AddingEmployee({super.key, required this.myDatabase});

  @override
  State<AddingEmployee> createState() => _AddingEmployeeState();
}

class _AddingEmployeeState extends State<AddingEmployee> {
  //
  final FocusNode _focusNode = FocusNode();
  final TextEditingController idCont = TextEditingController();
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController designationCont = TextEditingController();
  bool isFemale = false;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adding Employee'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Emp Id
              TextField(
                controller: idCont,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Employee Id',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              // Emp Name
              TextField(
                controller: nameCont,
                decoration: const InputDecoration(
                  hintText: 'Employee Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              // Emp Designation
              TextField(
                controller: designationCont,
                decoration: const InputDecoration(
                  hintText: 'Employee Designation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              // Emp Gender
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'Male',
                        style: TextStyle(
                          fontWeight:
                          isFemale ? FontWeight.normal : FontWeight.bold,
                          color: isFemale ? Colors.grey : Colors.blue,
                        ),
                      ),
                      Icon(
                        Icons.male,
                        color: isFemale ? Colors.grey : Colors.blue,
                      ),
                    ],
                  ),
                  Switch(
                      value: isFemale,
                      onChanged: (newValue) {
                        //
                        setState(() {
                          isFemale = newValue;
                        });
                        //
                      }),
                  Row(
                    children: [
                      Text(
                        'Female',
                        style: TextStyle(
                          fontWeight:
                          isFemale ? FontWeight.bold : FontWeight.normal,
                          color: isFemale ? Colors.pink : Colors.grey,
                        ),
                      ),
                      Icon(
                        Icons.male,
                        color: isFemale ? Colors.pink : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        //
                        Employee employee = Employee(
                            empId: int.parse(idCont.text),
                            empName: nameCont.text,
                            empDesignation: designationCont.text,
                            isMale: !isFemale);
                        await widget.myDatabase.insertEmp(employee);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('${employee.empName} added.')));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                                  (route) => false);
                        }

                        //
                      },
                      child: const Text('Add')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        //
                        idCont.text = '';
                        nameCont.text = '';
                        designationCont.text = '';
                        isFemale = false;
                        setState(() {});
                        _focusNode.requestFocus();
                        //
                      },
                      child: const Text('Reset')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
