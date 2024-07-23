import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logAddToCart(String itemName) async {
    await _analytics.logEvent(
      name: 'add_to_cart',
      parameters: <String, dynamic>{
        'item_name': itemName,
      },
    );
  }

  Future<void> logPurchase(double amount, String itemName) async {
    await _analytics.logEvent(
      name: 'purchase',
      parameters: <String, dynamic>{
        'amount': amount,
        'item_name': itemName,
      },
    );
  }
}
