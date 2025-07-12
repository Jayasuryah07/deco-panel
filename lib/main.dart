import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'RoutesManagment/pages.dart';
import 'RoutesManagment/routes.dart';
import 'RoutesManagment/screen_bindings.dart';
import 'Util/Constant/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Conditional Firebase initialization
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBal17y1PxbqIAM7jl5AlPTnM5AXibiVI0',
        appId: '1:872125002397:android:35d6af0685296fe640da74',
        messagingSenderId: '872125002397',
        projectId: 'deco-panel',
        storageBucket: 'deco-panel.firebasestorage.app',
      ),
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDjRHg9BZ6Lq4sLaK7jwGPSJj0cWg-vAqA",
        appId: "1:872125002397:ios:f99354b206f5cb9b40da74",
        messagingSenderId: "872125002397",
        projectId: "deco-panel",
        storageBucket: "deco-panel.firebasestorage.app",
        // Add from Firebase Console if available
        iosBundleId: "com.deco.decoapp",
      ),
    );
  }
  await FirebaseMessaging.instance.requestPermission();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.color42B,
    // Background color of status bar
    statusBarIconBrightness: Brightness.light,
    // Color of icons (light = white icons)
    statusBarBrightness: Brightness.dark,
    // For iOS
    systemNavigationBarColor: AppColors.color42B,
    // Navigation bar background
    systemNavigationBarIconBrightness: Brightness.light,
    // Icons color in navigation bar
    systemNavigationBarDividerColor: AppColors.whiteColor,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DecoApp',
      color: Colors.white,
      theme: ThemeData(
        colorScheme:
            const ColorScheme.highContrastLight(background: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: RouteConstants.splashScreen,
      getPages: AllPages.getPages(),
      initialBinding: ScreenBindings(),
    );
  }
}
