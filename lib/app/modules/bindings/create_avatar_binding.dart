import 'package:character_ai_delta/app/modules/controllers/create_avatar_ctl.dart';
import 'package:get/get.dart';

class CreateAvatarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreateAvatarCTL());
  }
}
