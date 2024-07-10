import 'package:get/get.dart';

import '../controllers/dump_controller.dart';

class DumpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DumpController>(
      () => DumpController(),
    );
  }
}
