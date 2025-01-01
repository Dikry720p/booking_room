import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/auth_binding.dart';
import 'bindings/category_binding.dart';
import 'bindings/room_binding.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/room_page.dart';
import 'pages/room_detail_page.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Booking Room App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterPage(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: CategoryBinding(),
        ),
        GetPage(
          name: '/rooms',
          page: () => const RoomPage(),
          binding: RoomBinding(),
        ),
        GetPage(
          name: '/room-detail',
          page: () => const RoomDetailPage(),
          binding: RoomBinding(),
        ),
        GetPage(
          name: '/main',
          page: () => const MainPage(),
          binding: RoomBinding(),
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
