import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/features/ui/navigations/navigation_controller.dart';
import 'package:kikira/kiki_app.dart';

class NavigationMenu extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final controller = Get.put(NavigationController());
    controller.SelectedIndex.value= 0 ;

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
            backgroundColor: Colors.white,
            indicatorColor: colorManager.kikiFirozi,
            height: 80,
            elevation: 1,
            selectedIndex: controller.SelectedIndex.value,
            onDestinationSelected: (index) =>
                controller.SelectedIndex.value = index,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home , size: 35,), label: "Home"),
              NavigationDestination(
                  icon: Icon(Icons.search , size: 35,), label: "patient Search " ,),
              NavigationDestination(
                  icon: Icon(Icons.manage_search_rounded, size: 35,),
                  label: "By Date Search"),
            ]
        ),
      ),
      body: Obx(()=>controller.screens[controller.SelectedIndex.value] ,)
    );
  }
}
