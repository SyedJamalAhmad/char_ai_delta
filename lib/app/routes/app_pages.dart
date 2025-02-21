import 'package:character_ai_delta/app/modules/Admin/admin_character/bindings/admin_char_editbinding.dart';
import 'package:character_ai_delta/app/modules/Admin/admin_character/views/admin_charecter_editview.dart';
import 'package:character_ai_delta/app/modules/new_gems_screen/new_gems_view.dart';
import 'package:character_ai_delta/app/modules/views/no_connection_view.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../modules/Admin/admin_character/bindings/admin_character_binding.dart';
import '../modules/Admin/admin_character/views/admin_character_view.dart';
import '../modules/Admin/binding/admin_home_binding.dart';
import '../modules/Admin/views/admin_home_view.dart';
import '../modules/avatar/binding/avatar_view_binding.dart';
import '../modules/avatar/binding/intro_avatar_binding.dart';
import '../modules/avatar/views/avatar_view.dart';
import '../modules/avatar/views/intro_avatart.dart';
import '../modules/bindings/create_avatar_binding.dart';
import '../modules/bindings/gems_view_binding.dart';
import '../modules/bindings/gf_chat_view_binding.dart';
import '../modules/bindings/home_view_binding.dart';
import '../modules/bindings/nav_view_binding.dart';
import '../modules/bindings/settings_binding.dart';
import '../modules/bindings/splash_screen_binding.dart';
import '../modules/intro_screens/bindings/intro_screens_binding.dart';
import '../modules/intro_screens/views/intro_screens_view.dart';
import '../modules/views/create_avatar.dart';
import '../modules/views/gems_view.dart';
import '../modules/views/gf_chat_view.dart';
import '../modules/views/home_carousel_view.dart';
import '../modules/views/home_view.dart';
import '../modules/views/nav_view.dart';
import '../modules/views/settings_view.dart';
import '../modules/views/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SplashScreen; //? For User Build
  // static const INITIAL = Routes.AdminHomeView; //? For Admin Build
  // static const INITIAL =
  //     kDebugMode ? Routes.AdminHomeView : Routes.SplashScreen;

  static final routes = [
    GetPage(
      name: _Paths.SplashScreen,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HomeView,
      page: () => HomeView(),
      binding: HomeViewBinding(),
    ),
    GetPage(
      name: _Paths.HomeCarouselView,
      page: () => HomeCarouselView(),
      binding: HomeViewBinding(),
    ),
    GetPage(
      name: _Paths.GemsView,
      page: () => GemsView(),
      binding: GemsViewBinding(),
    ),
    GetPage(
      name: _Paths.GfChatView,
      page: () => GfChatView(),
      binding: GfChatViewBinding(),
    ),
    GetPage(
      name: _Paths.SettingsView,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.NavView,
      page: () => NavView(),
      binding: NavViewBinding(),
    ),
    GetPage(
      name: _Paths.CreateAvatar,
      page: () => CreateAvatar(),
      binding: CreateAvatarBinding(),
    ),
    GetPage(
      name: _Paths.AvatarHome,
      page: () => AvatarHome(),
      binding: AvatarViewBinding(),
    ),
    GetPage(
      name: _Paths.IntroAvatar,
      page: () => IntroAvatar(),
      binding: IntroAvatarBinding(),
    ),
    GetPage(
      name: _Paths.AdminHomeView,
      page: () => AdminHomeView(),
      binding: AdminHomeBinding(),
    ),
    GetPage(
      name: _Paths.INTRO_SCREENS,
      page: () => IntroScreensView(),
      binding: IntroScreensBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_CHARACTER,
      page: () => const AdminCharacterView(),
      binding: AdminCharacterBinding(),
    ),
    GetPage(
      name: _Paths.AdminCharEditView,
      page: () => AdminCharEditView(),
      binding: AdminCharEditBinding(),
    ),
    GetPage(
      name: _Paths.NEWGEMSVIEW,
      page: () => newGemsView(),
      // binding:(),
    ),
    GetPage(
      name: _Paths.noConnectionView,
      page: () => NoConnectionView(),
      // binding:(),
    ),
  ];
}
