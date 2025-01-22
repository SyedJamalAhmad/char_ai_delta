import 'package:character_ai_delta/app/modules/controllers/new_gf_chat_ctl.dart';
import 'package:get/get.dart';

class NewGfChatBinding extends Bindings {
  @override
  void dependencies() {
  Get.put(NewGfChatCtl());
  }
}
