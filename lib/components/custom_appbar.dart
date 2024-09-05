import 'package:flutter/material.dart';
import 'package:recce/components/custom_dialog.dart';
import 'package:recce/configs/color/color.dart';
import 'package:recce/configs/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? backbutton;

  const CustomAppbar({super.key, required this.title, this.backbutton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: backbutton ?? false,
      title: Row(
        //mainAxisAlignment: MainAxisAlignment.s,
        children: [
          Text(title,
              style: AppStyles.appBarTitle(context, AppColors.onPrimary)),
         // const Spacer(),
         // IconButton(onPressed: () async {}, icon: const Icon(Icons.refresh))
        ],
      ),
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(
        color: AppColors.onPrimary,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

Future<void> _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear all saved preferences, including login state
  Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
}
