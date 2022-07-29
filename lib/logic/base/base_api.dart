import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const apiDefaultLog = true;

abstract class ApiMap {
  Future<Dio> getClient() async {
    var options = await getOptions();

    options.validateStatus = validateStatus;

    var dio = Dio(options);
    if (apiDefaultLog) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }

    return dio;
  }

  FutureOr<BaseOptions> getOptions() => BaseOptions();

  ValidateStatus validateStatus = (status) => status != null && status < 500;

  void close(Dio client) {
    client.close();
  }
}
