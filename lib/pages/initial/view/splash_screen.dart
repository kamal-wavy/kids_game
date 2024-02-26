import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../image.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (context) {
          return Scaffold(
              body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Image.asset(
                    appSplashBg ,
                    // appKids ,
                // appLogo,
                fit: BoxFit.fill,
              ))
            ],
          ));
        });
  }
}
