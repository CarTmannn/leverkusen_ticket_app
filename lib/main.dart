import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ticket_app/app/modules/home/controllers/home_controller.dart';
import 'package:ticket_app/app/modules/list_ticket/controllers/list_ticket_controller.dart';
import 'package:ticket_app/app/modules/login/controllers/login_controller.dart';
import 'package:ticket_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:ticket_app/app/modules/top_up/controllers/top_up_controller.dart';
import 'app/routes/app_pages.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: Routes.INTRO,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
  HttpOverrides.global = MyHttpOverrides();
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(TopUpController());
  Get.put(ListTicketController());
  await initializeDateFormatting("id_ID", null);
}
