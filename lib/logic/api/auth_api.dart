import 'package:dio/dio.dart';
import 'package:marzy/logic/base/base_api.dart';

class AuthApi extends ApiMap {
  BaseOptions get options {
    var options = BaseOptions(baseUrl: "");
    // if (isWithToken) {
    //   var token = getIt<ApiConfigModel>().hetznerKey;
    //   assert(token != null);
    //   options.headers = {'Authorization': 'Bearer $token'};
    // }
    return options;
  }

  // Future<bool> isFreeToCreate() async {
  //   var client = await getClient();
  //
  //   Response serversReponse = await client.get('/servers');
  //   List servers = serversReponse.data['servers'];
  //   var server = servers.firstWhere(
  //         (el) => el['name'] == 'selfprivacy-server',
  //     orElse: null,
  //   );
  //   client.close();
  //   return server == null;
  // }
}
