import 'package:get/get.dart';

import 'employee_details_screen_logic.dart';

class EmployeeDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeDetailsScreenLogic());
  }
}
