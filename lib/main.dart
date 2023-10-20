import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical_exam/views/screens/SplashScreen.dart';
import 'package:practical_exam/views/screens/home_page.dart';
import 'package:practical_exam/views/screens/login_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      getPages: [
        GetPage(
          name: '/',
          page: () => SplashScreen(),
        ),
        GetPage(
          name: '/login_screen',
          page: () => LoginScreen(),
        ),
        GetPage(
          name: '/home_page',
          page: () => HomePage(),
        ),
      ],
    ),
  );
}
