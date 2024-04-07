import 'package:btl/bindings/general_bindings.dart';
import 'package:btl/routes/app_routes.dart';
import 'package:btl/utils/constants/colors.dart';
import 'package:btl/utils/constants/text_strings.dart';
import 'package:btl/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Texts.appName,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: GeneralBindings(),
      getPages: AppRoutes.pages,

      /// Show Loader or Circular Progress Indicator meanwhile Authentication Repository is deciding to show relevant screen.
      home: const Scaffold(backgroundColor: MyColors.primary, body: Center(child: CircularProgressIndicator(color: Colors.white))),
    );
  }
}
