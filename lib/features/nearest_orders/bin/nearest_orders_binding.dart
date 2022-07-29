import 'package:get/get.dart';
import 'package:marzy/features/nearest_orders/controller/nearest_orders_controller.dart';
import 'package:marzy/features/nearest_orders/controller/order_tab_controller.dart';

class NearestOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NearestOrdersController>(() => NearestOrdersController());
    Get.lazyPut<OrderTabController>(() => OrderTabController());
  }
}
