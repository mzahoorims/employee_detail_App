import 'package:flutter/material.dart';
import 'employee_detail.dart';
import 'home.dart';
import 'my_database.dart';

class EditEmployee extends StatefulWidget {
  final MyDatabase myDatabase;
  const EditEmployee(
      {super.key, required this.employee, required this.myDatabase});
  final Employee employee;

  //chnage1
  //change2

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  //
  final FocusNode _focusNode = FocusNode();
  final TextEditingController idCont = TextEditingController();
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController designationCont = TextEditingController();
  bool isFemale = false;
  //
  @override
  Widget build(BuildContext context) {
    //
    idCont.text = '${widget.employee.empId}';
    nameCont.text = widget.employee.empName;
    designationCont.text = widget.employee.empDesignation;
    isFemale = widget.employee.isMale ? false : true;
    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Employee'),
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
                enabled: false,
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
                        await widget.myDatabase.updateEmp(employee);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.orange,
                              content: Text('${employee.empName} updated.')));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                                  (route) => false);
                        }
                        //
                      },
                      child: const Text('Update')),
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
