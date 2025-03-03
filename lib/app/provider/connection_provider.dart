import 'dart:async';
import 'dart:developer' as developer;
import 'package:character_ai_delta/app/routes/app_pages.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ConnectionProvider with ChangeNotifier {
  bool _isConnect = true;
  bool get isConnect => _isConnect;
  bool _hasReachedHomeView = false;
  bool _redirectedFromSplashScreen = false;
  bool _ignoreConnectionCheck = false;
  bool get redirectedFromSplashScreen => _redirectedFromSplashScreen;
  bool get ignoreConnectionCheck => _ignoreConnectionCheck;
  bool get hasReachedHomeView => _hasReachedHomeView;

  void setIsConnect(bool condition) {
    if (_isConnect && condition) {
      developer.log("Already set to true");
    } else if (!_isConnect && condition) {
      developer.log("Changing isConnect to true");
      _isConnect = condition;
      Get.offAndToNamed(Routes.HomeCarouselView);
    } else {
      developer.log("Changing isConnect to false");
      _isConnect = condition;
      Get.toNamed(Routes.noConnectionView);
    }
    notifyListeners();
  }

  // Corrected constructor name
  ConnectionProvider() {
    runConnectivityListener();
  }

  void setReachedHomeView(bool condition) {
    _hasReachedHomeView = condition;
  }

  void setRedirectFromSplashScreen(bool condition) {
    _redirectedFromSplashScreen = condition;
  }

  void setIgnoreConnectionCheck(bool condition) {
    _ignoreConnectionCheck = condition;
  }

  void runConnectivityListener() {
    print("Value ignoreConnectionCheck $ignoreConnectionCheck");
    StreamSubscription<List<ConnectivityResult>> _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        developer.log(
            "Connected via: $result ${result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)}");
        if (redirectedFromSplashScreen && !ignoreConnectionCheck) {
          developer.log("inside redirection to splashScreen");
          // Get.toNamed(Routes.splashScreen);
          setRedirectFromSplashScreen(false);
          // _redirectedFromSplashScreen = false;
        } else if (!_isConnect && !ignoreConnectionCheck) {
          // Only notify if there's a change
          developer.log(
              "Connected via 2: $result ${result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)}");

          setIsConnect(true);
          // moveToHome(true);
        }
      } else {
        developer.log("No network connection");
        if (_isConnect && !ignoreConnectionCheck) {
          // Only notify if there's a change
          setIsConnect(false);
        }
      }
      developer.log("Connectivity Result: $result");
    });
  }
}
