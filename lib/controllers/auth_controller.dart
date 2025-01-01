import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/token_service.dart';
import '../models/login_model.dart';
import '../models/register_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final isLoading = false.obs;
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    checkLoginStatus();
    super.onInit();
  }

  Future<void> checkLoginStatus() async {
    try {
      final token = await TokenService.getToken();
      isLoggedIn.value = token != null;
      if (isLoggedIn.value) {
        Get.offAllNamed('/main');
      }
    } catch (e) {
      print('Error checking login status: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final model = LoginModel(email: email, password: password);

      final token = await _authService.login(model);
      if (token != null && token.isNotEmpty) {
        await TokenService.saveToken(token);
        isLoggedIn.value = true;
        Get.offAllNamed('/main');
        Get.snackbar(
          'Sukses',
          'Login berhasil!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception('Token tidak valid');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password,
      String passwordConfirmation) async {
    try {
      isLoading.value = true;
      final model = RegisterModel(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      await _authService.register(model);
      Get.offAllNamed('/login');
      Get.snackbar(
        'Sukses',
        'Registrasi berhasil!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await TokenService.removeToken();
      isLoggedIn.value = false;
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
