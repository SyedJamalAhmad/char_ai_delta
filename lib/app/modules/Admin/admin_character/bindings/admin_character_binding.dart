import 'package:get/get.dart';

import '../controllers/admin_character_controller.dart';

class AdminCharacterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCharacterController>(
      () => AdminCharacterController(),
    );
  }
}
