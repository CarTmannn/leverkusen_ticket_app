import 'package:get/get.dart';

import '../controllers/list_ticket_controller.dart';

class ListTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListTicketController>(
      () => ListTicketController(),
    );
  }
}
