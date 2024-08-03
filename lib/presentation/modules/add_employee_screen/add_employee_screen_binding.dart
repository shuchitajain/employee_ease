import 'package:get/get.dart';

import 'add_employee_screen_logic.dart';

class AddEmployeeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddEmployeeScreenLogic());
  }
}
