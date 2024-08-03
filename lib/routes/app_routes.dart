import 'package:employee_ease/presentation/modules/employees_list_screen/employees_list_screen_binding.dart';
import 'package:employee_ease/presentation/modules/employees_list_screen/employees_list_screen_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import '../presentation/modules/add_employee_screen/add_employee_screen_binding.dart';
import '../presentation/modules/add_employee_screen/add_employee_screen_view.dart';
import '../presentation/modules/employee_details_screen/employee_details_screen_binding.dart';
import '../presentation/modules/employee_details_screen/employee_details_screen_view.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static const String employeeDetailsScreen = '/employees_details_screen';
  static const String addEmployeeScreen = '/add_employee_screen';

  static final pages = [
    GetPage(
      name: '/',
      page: () => const EmployeesListScreenView(),
      binding: EmployeesListScreenBinding(),
    ),
    GetPage(
      name: employeeDetailsScreen,
      page: () => const EmployeeDetailsScreenView(),
      binding: EmployeeDetailsScreenBinding(),
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: addEmployeeScreen,
      page: () => const AddEmployeeScreenView(),
      binding: AddEmployeeScreenBinding(),
    ),
  ];
}