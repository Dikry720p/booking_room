import 'package:get/get.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';
import '../services/token_service.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  final categories = <CategoryModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      final token = await TokenService.getToken();
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final result = await _categoryService.getCategories(token);
      categories.value = result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat kategori: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
