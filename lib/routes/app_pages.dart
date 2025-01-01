import 'package:get/get.dart';
import '../bindings/category_binding.dart';
import '../pages/home_page.dart';
// ... import lainnya ...

class AppPages {
  static final routes = [
    GetPage(
      name: '/home',
      page: () => const HomePage(),
      binding: CategoryBinding(),
    ),
    // ... route lainnya ...
  ];
}
