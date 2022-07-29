import 'package:get/get.dart';
import 'package:marzy/features/waiting_orders_detail/controller/waiting_orders_detail_controller.dart';

class WaitingOrdersDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaitingOrdersDetailController>(
        () => WaitingOrdersDetailController());
  }
}
