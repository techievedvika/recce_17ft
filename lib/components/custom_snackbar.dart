
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recce/configs/color/color.dart';

 customSnackbar(String? title, String? subtitle, Color? bgColor,
    Color? textColor, IconData? logoIcon) {
  Get.snackbar(
    title!,
    subtitle!,
    
    snackPosition: SnackPosition.TOP,
    colorText: textColor,
    backgroundColor: bgColor,
    icon: Icon(logoIcon, color:AppColors.onPrimary),
  );
}