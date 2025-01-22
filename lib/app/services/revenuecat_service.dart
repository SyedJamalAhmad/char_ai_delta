import 'dart:developer' as dp;
// import 'package:ai_chatbot/app/modules/routes/app_pages.dart';
// import 'package:flutter_gif/flutter_gif.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:character_ai_delta/app/modules/controllers/home_view_ctl.dart';
import 'package:character_ai_delta/app/routes/app_pages.dart';
import 'package:character_ai_delta/app/services/firebase_services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../modules/home/controllers/nav_view_ctl.dart';
// import '../modules/utills/Gems_rates.dart';

// class RevenueCatIDs {
//   // static const idGems10 = '10_gems';
//   static const removeAdID = 'aislide_adremove_1';

//   static const allids = [
//     // idGems10,
//     removeAdID
//   ];
// }

class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();

  factory RevenueCatService() {
    // Purchases.setEmail(email)
    return _instance;
  }

  RevenueCatService._internal();

  Rx<Entitlement> currentEntitlement = Entitlement.free.obs;

  final List<String> _productIds = [
    // Add your product identifiers here
    'beta_char_adremove_1',
    'beta_char_gems_200',
    'beta_char_gems_500',
    // 'lifetime_premium',
  ];
  static const _apiKey = 'goog_axQhifbtwvVFhykmmrLtGFLCJmc';

  Future<void> initialize() async {
    // String customerID="ranasherry94@gmail.com";

    return; //TODO: Uncomment after actual implementation
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(PurchasesConfiguration(_apiKey))
        .then((value) async {
      // getRemoveAdProduct();
      getAllProducts();
      FirestoreService().UserID = await Purchases.appUserID;
      await checkSubscriptionStatus();

      if (currentEntitlement.value == Entitlement.paid) {
        try {
          CreateFirebaseUser();
        } catch (e) {
          dp.log("Firebase Error: $e");
        }
      }
    });

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      updatePurchaseStatus();
    });
  }

  Future<StoreProduct?> getRemoveAdProduct() async {
    final offerings = await Purchases.getOfferings();
    final packages = offerings.getOffering("remove_ads")?.availablePackages;
    if (packages != null) {
      StoreProduct storeProduct = packages.first.storeProduct;
      print("StoreProduct : ${storeProduct}");

      return storeProduct;
    }

    return null;
  }

  Future<List<StoreProduct>> getAllProducts() async {
    List<StoreProduct> products = [];
    final offerings = await Purchases.getOfferings();
    final currentOffering = offerings.current;
    if (currentOffering != null) {
      final allPackages = currentOffering.availablePackages;
      for (var package in allPackages) {
        products.add(package.storeProduct);
        dp.log("Products: ${package.storeProduct}");
      }
    }
    return products;
  }

  void printWrapped(String text) =>
      RegExp('.{1,800}').allMatches(text).map((m) => m.group(0)).forEach(print);

  Future<void> purchaseSubscription(Package package) async {
    try {
      final purchaserInfo =
          await Purchases.purchasePackage(package).then((value) {});

      dp.log("Purchased ${purchaserInfo}");
      // Handle successful purchase
    } catch (error) {
      print("Purchase Error");
      // Handle purchase error
    }
  }

  Future<void> PurchaseProduct(StoreProduct product) async {
    EasyLoading.show(status: "Please Wait...");
    try {
      // print("CostumerInfo before: ${purchaserInfo.allPurchasedProductIdentifiers}");

      final purchaserInfo = await Purchases.purchaseStoreProduct(product);

      if (purchaserInfo != null) {
        PurchaseType productType = getPrductType(product.identifier);

        productPurchased(productType);
        if (kReleaseMode)
          FirebaseAnalytics.instance.logPurchase(
              currency: product.currencyCode,
              value: product.price,
              items: [
                AnalyticsEventItem(
                    itemId: product.identifier, price: product.price)
              ]);
      }

      print("CostumerInfo after: ${purchaserInfo}");

      // Handle successful purchase
    } catch (error) {
      EasyLoading.dismiss();
      dp.log("Purchase Error: $error");
      // Handle purchase error
    }
  }

  Future<void> checkSubscriptionStatus() async {
    try {
      final purchaserInfo = await Purchases.getCustomerInfo();
      print(
          "CheckSubscription: ${purchaserInfo.allPurchasedProductIdentifiers}");
      if (purchaserInfo.allPurchasedProductIdentifiers
          .contains("aislide_adremove_1")) {}
    } catch (error) {
      // Error occurred while fetching the subscription status
      print('Error: $error');
    }
  }

  Future updatePurchaseStatus() async {
    try {
      final purchaserInfo = await Purchases.getCustomerInfo();
      print("Purchase info: $purchaserInfo");
      // if (purchaserInfo.entitlements.active.isNotEmpty) {
      //   currentEntitlement.value = Entitlement.paid;
      //   // User is subscribed
      //   print('User is subscribed');
      // } else {
      //   currentEntitlement.value = Entitlement.free;

      //   // User is not subscribed
      //   print('User is not subscribed');
      // }
    } catch (error) {
      // Error occurred while fetching the subscription status
      print('Error: $error');
    }
  }

  void GoToPurchaseScreen() {
    if (currentEntitlement.value == Entitlement.paid) return;
    Get.toNamed(
      Routes.GemsView,
    );
  }

  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  RemoveAdsForUser() async {
    final prefs = await getSharedPrefs();
    await prefs.setBool('isAdRemoved', true);

    RevenueCatService().currentEntitlement.value = Entitlement.paid;
    dp.log("RemoveAdsForUser Called");
    CheckRemoveAdsForUser();

    // Get.back();
    // Get.offAllNamed(Routes.HomeView);
    Get.back();
  }

  Future<bool> CheckRemoveAdsForUser() async {
    final prefs = await getSharedPrefs();
    final isAdRemoved = prefs.getBool('isAdRemoved') ?? false;

    if (isAdRemoved) {
      RevenueCatService().currentEntitlement.value = Entitlement.paid;
    } else {
      RevenueCatService().currentEntitlement.value = Entitlement.free;
    }
    dp.log("IsAdRemoved: $isAdRemoved");
    dp.log(
        "CurrentEntitlement: ${RevenueCatService().currentEntitlement.value}");

    return isAdRemoved;
  }

  void CreateFirebaseUser() {
    // FirestoreService().createUser(uid: FirestoreService().UserID);
  }

  String getGemAmount(StoreProduct product) {
    if (product.identifier == "chatai_200_gems") {
      return "200 Gems";
    } else if (product.identifier == "chatai_500_gems") {
      return "500 Gems";
    } else if (product.identifier == "chatai_removead_combo1") {
      return "Remove Ads & 500 Gems";
    } else {
      return product.title;
    }
  }

  PurchaseType getPrductType(identifier) {
    if (identifier == "chatai_200_gems") {
      return PurchaseType.GEMS_200;
    } else if (identifier == "chatai_500_gems") {
      return PurchaseType.GEMS_500;
    } else if (identifier == "chatai_removead_combo1") {
      return PurchaseType.REMOMVEAD_COMBO;
    } else {
      return PurchaseType.OTHER;
    }
  }

  void productPurchased(PurchaseType productType) {
    switch (productType) {
      case PurchaseType.GEMS_200:
        increaseGems(200);

        break;
      case PurchaseType.GEMS_500:
        increaseGems(500);
        break;
      case PurchaseType.REMOMVEAD_COMBO:
        unlockCombo();
        break;
      case PurchaseType.OTHER:
        RemoveAdsForUser();
        break;
      default:
    }

    EasyLoading.dismiss();
  }

  increaseGems(int value) {
    HomeViewCTL homectl = Get.find();

    homectl.increaseGEMS(value);
    EasyLoading.showSuccess("Congratulations! You have recieved $value Gems");
    EasyLoading.dismiss();
  }

  void unlockCombo() {
    RemoveAdsForUser();
    increaseGems(500);
  }
}

enum Entitlement { free, paid }

enum PurchaseType { GEMS_200, GEMS_500, REMOMVEAD_COMBO, OTHER }
