import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/app/modules/home/controllers/home_controller.dart';
import 'package:ticket_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  double positionY = 0;
  HomeController ip = HomeController();
  var isLoading = true.obs;
  var saldo = 0.obs;
  var tickets = [].obs;
  var name = ''.obs;
  var gender = ''.obs;
  var birthDate = ''.obs;
  var customerId = 0.obs;
  var photo = ''.obs;
  var email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString('name') ?? '';
    saldo.value = int.parse(prefs.getString('balance') ?? '0');
    gender.value = prefs.getString('gender') ?? '';
    birthDate.value = prefs.getString('birthdate') ?? '';
    customerId.value = prefs.getInt('customer_id') ?? 0;
    photo.value = prefs.getString('photo') ?? '';
    email.value = prefs.getString('emailView') ?? '';
  }

  void updatePosition(double newPositionY) {
    positionY = newPositionY;
    update();
  }

  Future<void> getSaldo(int customer_id) async {
    final response = await http.post(
      Uri.parse('http://${ip.ip}:8080/fetch_saldo'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "customer_id": customer_id,
      }),
    );

    if (response.statusCode == 200) {
      final balance = int.tryParse(response.body);
      if (balance != null) {
        saldo.value = balance;
      } else {
        print('Failed to parse balance value');
      }
    } else {
      print('Failed to fetch saldo: ${response.statusCode}');
    }
    isLoading.value = false;
  }

  Future<void> getTicket(int customer_id) async {
    final response = await http.post(
      Uri.parse('http://${ip.ip}:8080/fetch_ticket'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "customer_id": customer_id,
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is List) {
        tickets.value = jsonData;
      } else {
        print('Invalid response format');
      }
    } else {
      print('Failed to fetch tickets: ${response.statusCode}');
    }
    isLoading.value = false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
  }
}
