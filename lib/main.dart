import 'package:cafeysadmin/firebase_options.dart';
import 'package:cafeysadmin/splash_screen_page.dart';
import 'package:cafeysadmin/util/app_colors.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HomeApp());
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appLabel,
      theme: ThemeData(primarySwatch: AppColors.materialColor(AppColors.primary)),
      home: const SplashScreenPage(),
    );
  }
}
