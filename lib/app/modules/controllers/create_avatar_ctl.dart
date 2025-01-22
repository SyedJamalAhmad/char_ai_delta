import 'package:character_ai_delta/app/data/user_avatar.dart';
import 'package:character_ai_delta/app/provider/useravatar_dbhelper.dart';
import 'package:get/get.dart';

class CreateAvatarCTL extends GetxController {
  RxList<UserPersonalizedAvatar> userAvatars = <UserPersonalizedAvatar>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    fetchAvatars();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> fetchAvatars() async {
    print("FetchUserCalled..");
    try {
      final avatars = await UserAvatarDatabaseHelper.db.getAvatars();
      userAvatars.value = avatars; // Update the observable list
    } catch (error) {
      print('Error fetching avatars: $error');
      // Handle error appropriately, e.g., show an error message
    }
  }
}
