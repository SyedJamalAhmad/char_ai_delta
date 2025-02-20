import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NoConnectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black, // Dark background
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated WiFi Icon
              Icon(Icons.wifi_off, size: 100, color: Colors.white)
                  .animate(
                      onPlay: (controller) => controller.repeat(reverse: true))
                  .scaleXY(begin: 1.0, end: 1.2, duration: 1.seconds),

              SizedBox(height: 20),

              // Main Text
              Text(
                "No Internet Connection",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),

              SizedBox(height: 10),

              // Subtext
              Text(
                "Please connect to the internet to access the app.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
