import 'package:get/get.dart';

import 'employees_list_screen_logic.dart';

class EmployeesListScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeesListScreenLogic());
  }
}
