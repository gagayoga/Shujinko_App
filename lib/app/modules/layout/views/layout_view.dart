import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:shujinko_app/app/components/customBarMaterial.dart';
import 'package:shujinko_app/app/modules/bookmark/views/bookmark_view.dart';
import 'package:shujinko_app/app/modules/buku/views/buku_view.dart';

import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/layout_controller.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    // const Color colorText = Color(0xFFEA1818);
    const Color background = Color(0xFF03010E);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: background,
      statusBarIconBrightness: Brightness.light,// Change this color as needed
    ));

    return GetBuilder<LayoutController>(
        builder: (controller) {
          return Scaffold(
              body: Center(
                  child: IndexedStack(
                    index: controller.tabIndex,
                    children: [
                      HomeView(),
                      BukuView(),
                      BookmarkView(),
                      ProfileView(),
                    ],
                  )
              ),
              bottomNavigationBar: CustomBottomBarMaterial(
                onTap: controller.changeTabIndex,
                currentIndex: controller.tabIndex,
              )
          );
        }
    );
  }
}