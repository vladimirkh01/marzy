import 'package:get/get.dart';
import 'package:marzy/features/standing_order/controller/standing_order_controller.dart';

class StandingOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StandingOrderController>(() => StandingOrderController());
  }
}
