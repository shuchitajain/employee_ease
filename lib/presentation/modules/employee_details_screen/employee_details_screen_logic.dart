import 'package:employee_ease/data/api/api_base_helper.dart';
import 'package:employee_ease/data/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/contact_methods_model.dart';
import '../../../utils/app_colors.dart';
import '../employees_list_screen/employees_list_screen_logic.dart';

class EmployeeDetailsScreenLogic extends GetxController {
  var arguments = Get.arguments;
  EmployeeModel employee = Get.arguments;
  RxBool isEditing = false.obs;
  final formKey = GlobalKey<FormState>();
  Rx<Color> labelColor = AppColors.hintAndLabelColor.obs, iconColor = AppColors.hintAndLabelColor.obs;
  final Map<String, TextEditingController> textControllers = {
    'Name': TextEditingController(),
    'Line 1': TextEditingController(),
    'City': TextEditingController(),
    'Country': TextEditingController(),
    'Zip code': TextEditingController(),
    'Email address': TextEditingController(),
    'Phone number': TextEditingController(),
  };
  final focusNodes = {
    'Name': FocusNode().obs,
    'Line 1': FocusNode().obs,
    'City': FocusNode().obs,
    'Country': FocusNode().obs,
    'Zip code': FocusNode().obs,
    'Email address': FocusNode().obs,
    'Phone number': FocusNode().obs,
  };

  @override
  void onInit() {
    super.onInit();
    textControllers['Name']!.text = employee.name;
    textControllers['Line 1']!.text = employee.address.line1;
    textControllers['City']!.text = employee.address.city;
    textControllers['Country']!.text = employee.address.country;
    textControllers['Zip code']!.text = employee.address.zipCode;
    textControllers['Email address']!.text = employee.contactMethods
        .firstWhere((method) => method.contactMethod == 'email', orElse: () => ContactMethod(contactMethod: 'email', value: ''))
        .value;
    textControllers['Phone number']!.text = employee.contactMethods
        .firstWhere((method) => method.contactMethod == 'phone', orElse: () => ContactMethod(contactMethod: 'phone', value: ''))
        .value;
    focusNodes.forEach((label, focusNode) {
      focusNode.value.addListener(() {});
    });
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    if(focusNodes[label]!.value.hasFocus){
      labelColor.value = AppColors.secondaryColor;
      iconColor.value = AppColors.secondaryColor;
    } else {
      labelColor.value = AppColors.hintAndLabelColor;
      iconColor.value = AppColors.hintAndLabelColor;
    }
    return InputDecoration(
      labelText: label,
      floatingLabelStyle: TextStyle(
        color: labelColor.value,
        fontSize: 20.sp,
      ),
      floatingLabelAlignment: FloatingLabelAlignment.start,
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 20.w, top: 14.h),
        child: FaIcon(
          icon,
          color: iconColor.value,
          size: 16.h,
        ),
      ),
      contentPadding: EdgeInsets.only(left: 46.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.r),
        borderSide: BorderSide(
          width: 2,
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }

  Future<void> saveEmployeeDetails() async {
    employee.name = textControllers['Name']!.text;
    employee.address = Address(
      line1: textControllers['Line 1']!.text,
      city: textControllers['City']!.text,
      country: textControllers['Country']!.text,
      zipCode: textControllers['Zip code']!.text,
    );
    employee.contactMethods = [
      ContactMethod(
        contactMethod: 'email',
        value: textControllers['Email address']!.text,
      ),
      ContactMethod(
        contactMethod: 'phone',
        value: textControllers['Phone number']!.text,
      ),
    ];
    var result = await ApiBaseHelper().patchData(
      '/${employee.id}',
      employee.toJson(),
    );
    toggleEditing();
    if (result['message'] == 'Record updated.') {
      Get.showSnackbar(
        const GetSnackBar(
          message: 'Employee details updated successfully!',
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(Get.context!);
        var employeesListLogic = Get.find<EmployeesListScreenLogic>();
        var employeeIndex = employeesListLogic.filteredEmployees.indexWhere((emp) => emp.id == employee.id);
        if (employeeIndex != -1) {
          employeesListLogic.filteredEmployees[employeeIndex] = employee;
        }
      });
    }
  }

  @override
  void onClose() {
    focusNodes.forEach((label, focusNode) {
      focusNode.value.dispose();
    });
    super.onClose();
  }
}
