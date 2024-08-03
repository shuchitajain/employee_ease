import 'package:employee_ease/data/api/api_base_helper.dart';
import 'package:employee_ease/data/models/employee_model.dart';
import 'package:employee_ease/presentation/modules/employees_list_screen/employees_list_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/address_model.dart';
import '../../../data/models/contact_methods_model.dart';

class AddEmployeeScreenLogic extends GetxController {
  final formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> textControllers = {
    'Name': TextEditingController(text: ''),
    'Line 1': TextEditingController(text: ''),
    'City': TextEditingController(text: ''),
    'Country': TextEditingController(text: ''),
    'Zip code': TextEditingController(text: ''),
    'Email address': TextEditingController(text: ''),
    'Phone number': TextEditingController(text: ''),
  };

  final Map<String, FocusNode> focusNodes = {
    'Name': FocusNode(),
    'Line 1': FocusNode(),
    'City': FocusNode(),
    'Country': FocusNode(),
    'Zip code': FocusNode(),
    'Email address': FocusNode(),
    'Phone number': FocusNode(),
  };

  @override
  void onInit() {
    debugPrint('INIT');
    super.onInit();
    focusNodes.forEach((label, focusNode) {
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          _moveCursorToStart(textControllers[label]!);
        }
      });
    });
  }

  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      debugPrint('Form is valid');
      EmployeeModel emp = EmployeeModel(
        name: textControllers['Name']!.text,
        address: Address(
          line1: textControllers['Line 1']!.text,
          city: textControllers['City']!.text,
          country: textControllers['Country']!.text,
          zipCode: textControllers['Zip code']!.text,
        ),
        contactMethods: [
          ContactMethod(
            contactMethod: 'email',
            value: textControllers['Email address']!.text,
          ),
          ContactMethod(
            contactMethod: 'phone',
            value: textControllers['Phone number']!.text,
          ),
        ],
      );
      Map<String,dynamic> response = await ApiBaseHelper().postData(
        '',
        emp.toJson(),
      );
      String? empId = response["id"];
      if(empId != null){
        emp.id = empId;
        emp.dateAdded = DateTime.now();
        debugPrint('New employee added on ${emp.dateAdded}');
        Get.showSnackbar(
          const GetSnackBar(
            message: 'Employee added successfully!',
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          debugPrint('Popping');
          Navigator.pop(Get.context!);
          Get.find<EmployeesListScreenLogic>().addEmployee(emp);
        });
      }
      else {
        Get.showSnackbar(
          const GetSnackBar(
            message: 'Failed to add employee',
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      debugPrint('Form is invalid');
    }
  }

  void _moveCursorToStart(TextEditingController controller) {
    final text = controller.text;
    debugPrint('Text is $text');
    if (text.isNotEmpty) {
      controller.selection = const TextSelection.collapsed(offset: 0);
    }
  }

  @override
  void dispose() {
    for (var controller in textControllers.values) {
      controller.dispose();
    }
    for (var focusNode in focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
