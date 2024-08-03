import 'package:get/get.dart';
import '../data/api/api_base_helper.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    //Api
    Get.put(ApiBaseHelper(), permanent: true);
  }
}
