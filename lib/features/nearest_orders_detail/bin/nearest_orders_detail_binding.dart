import 'package:get/get.dart';
import 'package:marzy/features/nearest_orders_detail/controller/nearest_orders_detail_controller.dart';

class NearestOrdersDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NearestOrdersDetailController>(
        () => NearestOrdersDetailController());
  }
}
