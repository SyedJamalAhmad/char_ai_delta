import 'package:character_ai_delta/app/modules/views/create_avatar.dart';
import 'package:get/get.dart';

import '../views/home_view.dart';
import '../views/settings_view.dart';

class NavCTL extends GetxController {
  RxInt current_index = 0.obs;

  int navAdCounter = 1;
  final screens = [
    HomeView(),
    CreateAvatar(),
    SettingsView(),
  ];
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
