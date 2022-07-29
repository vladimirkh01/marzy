import 'package:get_it/get_it.dart';
import 'package:marzy/logic/services/navigation_service.dart';

final getIt = GetIt.instance;

Future<void> getItSetup() async {
  getIt.registerSingleton<NavigationService>(NavigationService());
  await getIt.allReady();
}
