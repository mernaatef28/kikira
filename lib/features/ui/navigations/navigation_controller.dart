import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kikira/features/ui/screens/filterbydate.dart';
import 'package:kikira/features/ui/screens/indivisual_search.dart';
import 'package:kikira/kiki_app.dart';

class NavigationController extends GetxController {

  final Rx<int> SelectedIndex = 0.obs ;
  final screens = [KikiRaApp() ,IndivisualSearch() , FilterByDate()] ;
}