import 'package:get/get.dart';

import '../controllers/gf_chat_view_controller.dart';

class GfChatViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GfChatViewController>(
      () => GfChatViewController(),
    );
  }
}
