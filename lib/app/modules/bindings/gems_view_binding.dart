import 'package:get/get.dart';

import '../controllers/gems_view_controller.dart';

class GemsViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GemsViewController>(
      () => GemsViewController(),
    );
  }
}
