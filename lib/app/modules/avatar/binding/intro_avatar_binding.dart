import 'package:character_ai_delta/app/modules/avatar/controller/intro_avatar_ctl.dart';
import 'package:get/get.dart';

class IntroAvatarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(IntroAvatarCTL());
  }
}
