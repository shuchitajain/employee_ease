import 'package:employee_ease/data/api/api_base_helper.dart';
import 'package:employee_ease/data/models/employee_model.dart';
import 'package:employee_ease/presentation/modules/add_employee_screen/add_employee_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../add_employee_screen/add_employee_screen_view.dart';

class EmployeesListScreenLogic extends GetxController
    with GetTickerProviderStateMixin {
  final RxList<EmployeeModel> _employees = <EmployeeModel>[].obs, filteredEmployees = <EmployeeModel>[].obs;
  final RxMap<String, AnimationController> animationControllers =
      <String, AnimationController>{}.obs;
  var sortCriteria = 'A-Z'.obs;
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void onInit() {
    super.onInit();
    getEmployeesList();
  }

  void filterEmployees(String query) {
    if (query.isEmpty) {
      filteredEmployees.assignAll(_employees);
    } else {
      filteredEmployees.assignAll(
        _employees.where((employee) => employee.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  void setSortCriteria(String criteria) {
    sortCriteria.value = criteria;
    sortEmployees();
  }

  void sortEmployees() {
    if (sortCriteria.value == 'A-Z') {
      filteredEmployees.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortCriteria.value == 'Z-A') {
      filteredEmployees.sort((a, b) => b.name.compareTo(a.name));
    } else if (sortCriteria.value == 'Date Added') {
      filteredEmployees.sort((a, b) => a.dateAdded!.compareTo(b.dateAdded!));
    }
  }

  void initializeAnimationController(String id) {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animationControllers[id] = controller;
  }

  Future<void> getEmployeesList() async {
    await ApiBaseHelper().getData('').then((emps) {
      if (emps != null) {
        _employees.clear();
        filteredEmployees.clear();
        emps['data'].forEach((emp) {
          final employee = EmployeeModel.fromJson(emp);
          _employees.add(employee);
          final animationController = AnimationController(
            duration: const Duration(milliseconds: 300),
            vsync: this,
          );
          animationControllers[employee.id!] = animationController;
          debugPrint('Employee: ${employee.name}');
        });
      }
    });
    filteredEmployees.assignAll(_employees);
  }

  Future<void> refreshData() async{
    await getEmployeesList().then((value) {
      Get.snackbar('Refreshed', 'Employee list refreshed successfully');
    });
  }

  void openAddEmployeeSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GetBuilder<AddEmployeeScreenLogic>(
        init: AddEmployeeScreenLogic(),
        builder: (_) => const AddEmployeeScreenView(),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: Scaffold.of(context),
      ),
    );
  }

  void addEmployee(EmployeeModel employee){
    initializeAnimationController(employee.id!);
    _employees.add(employee);
    filteredEmployees.add(employee);
    //filterEmployees('');
    debugPrint('Added employee: ${employee.name}');
  }

  void deleteEmployee(String id) {
    final animationController = animationControllers[id];
    if (animationController != null) {
      animationController.forward().then((_) {
        ApiBaseHelper().deleteData('/$id').then((result) {
          if (result['message'] == 'Record deleted.') {
            _employees.removeWhere((employee) => employee.id == id);
            filteredEmployees.removeWhere((employee) => employee.id == id);
            //filterEmployees('');
            animationControllers[id]?.dispose();
            animationControllers.remove(id);
            debugPrint('Deleted employee: $id');
          }
        });
      });
    }
  }

  @override
  void dispose() {
    for (var controller in animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

}
