import 'package:character_ai_delta/app/modules/Admin/admin_character/controllers/admin_char_edit_ctl.dart';
import 'package:get/get.dart';

import '../controllers/admin_character_controller.dart';

class AdminCharEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCharEditCTL>(
      () => AdminCharEditCTL(),
    );
  }
}
