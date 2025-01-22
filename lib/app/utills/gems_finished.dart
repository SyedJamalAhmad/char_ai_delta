import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GemsFinished extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('No more Gems Avilable'),
      content: Text('Sorry, there are no Gems available at the moment.'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}