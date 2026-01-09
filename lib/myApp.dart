import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/pages/app_pages.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        primaryColor: Colors.white,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        cardColor: Colors.white,
        canvasColor: Colors.white,
        dialogTheme: DialogThemeData(backgroundColor: Colors.white),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: ColorStyle.colorSecondary.withValues(alpha: 0.7),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          selectedLabelStyle: AppTextStyle.smallText.copyWith(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: AppTextStyle.smallText.copyWith(
            fontWeight: FontWeight.w200,
          ),
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
