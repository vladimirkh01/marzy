import 'package:get/get.dart';
import 'package:marzy/features/waiting_orders_detail/page/waiting_orders_detail.dart';

class WaitingOrdersController extends GetxController {
  Future<void> goToWaitingOrdersDetail() async {
    Get.toNamed(WaitingOrdersDetailPage.route);
  }
}
