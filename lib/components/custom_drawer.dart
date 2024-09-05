// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recce/components/component.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
         

          

          Container(
            color: AppColors.background,
            height: responsive.responsiveValue(
                small: 200.0, medium: 210.0, large: 220.0),
            width: responsive.responsiveValue(
                small: 320.0, medium: 330.0, large: 340.0),
            child:   Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
            decoration:  const BoxDecoration(
              border: Border(),
              shape: BoxShape.circle,
              color: AppColors.background,
              image: DecorationImage(image: AssetImage('assets/check.png'))
            ),

          ),
            ),
          ),
          DrawerMenu(
              title: 'Home',
              icons: const FaIcon(FontAwesomeIcons.home),
              onPressed: () {
               
              }),
         
        
        ],
      ),
    );
  }
}

class DrawerMenu extends StatelessWidget {
  String? title;
  FaIcon? icons;
  Function? onPressed;
  DrawerMenu({
    super.key,
    this.title,
    this.icons,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icons,
      title: Text(title ?? '',
          style: AppStyles.inputLabel(context, AppColors.onBackground,14)),
      onTap: () {
        if (onPressed != null) {
          onPressed!(); // Call the function using parentheses
        }
      },
    );
  }
}
