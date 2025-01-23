part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SplashScreen = _Paths.SplashScreen;
  static const HomeView = _Paths.HomeView;
  static const GemsView = _Paths.GemsView;
  static const GfChatView = _Paths.GfChatView;
  // static const ChatScreen = _Paths.ChatScreen;
  // static const ChatSuggestion = _Paths.ChatSuggestion;
  static const SettingsView = _Paths.SettingsView;
  static const NavView = _Paths.NavView;
  static const CreateAvatar = _Paths.CreateAvatar;
  static const AvatarHome = _Paths.AvatarHome;
  static const IntroAvatar = _Paths.IntroAvatar;
  static const AdminHomeView = _Paths.AdminHomeView;
  static const INTRO_SCREENS = _Paths.INTRO_SCREENS;
  static const ADMIN_CHARACTER = _Paths.ADMIN_CHARACTER;
  static const AdminCharEditView = _Paths.AdminCharEditView;
  static const NEWGEMSVIEW = _Paths.NEWGEMSVIEW;
}

abstract class _Paths {
  static const SplashScreen = '/SplashScreen';
  static const HomeView = '/HomeView';
  static const GemsView = '/GemsView';
  static const GfChatView = '/GfChatView';
  // static const ChatScreen = '/ChatScreen';
  // static const ChatSuggestion = '/ChatSuggestion';
  static const SettingsView = '/SettingsView';
  static const NavView = '/NavView';
  static const CreateAvatar = '/CreateAvatar';
  static const AvatarHome = '/AvatarHome';
  static const IntroAvatar = '/IntroAvatar';
  static const AdminHomeView = '/AdminHomeView';
  static const INTRO_SCREENS = '/intro-screens';
  static const ADMIN_CHARACTER = '/admin-character';
  static const AdminCharEditView = '/AdminCharEditView';
  static const NEWGEMSVIEW = '/NEWGEMSVIEW';
}
