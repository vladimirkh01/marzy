import 'package:get/get.dart';
import 'package:marzy/features/waiting_orders/controller/waiting_orders_controller.dart';

class WaitingOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaitingOrdersController>(() => WaitingOrdersController());
  }
}
