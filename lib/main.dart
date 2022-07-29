import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/features/home/page/home.dart';
import 'package:marzy/logic/services/navigation_service.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'features/splash/views/splash.dart';
import 'logic/config/get_it_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  await getItSetup();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (BuildContext context, _) {
        return FutureBuilder(
          future: getParamAuth(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.data != null) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  scaffoldMessengerKey:
                  getIt.get<NavigationService>().scaffoldMessengerKey,
                  navigatorKey: getIt.get<NavigationService>().navigatorKey,
                  title: 'Marzy+',
                  theme: ThemeData(
                    scaffoldBackgroundColor: AppColors.white,
                    elevatedButtonTheme: AppThemes.kElevationButtonTheme,
                    appBarTheme: AppThemes.kAppBarTheme,
                    textTheme: AppThemes.kTextTheme,
                    textButtonTheme: AppThemes.textButtonTheme,
                    inputDecorationTheme: AppThemes.kInputDecorationTheme,
                  ),
                  home: snapshot.data,
              );
            } else return Container();
          },
        );
      }
    );
  }

  Future<Widget> getParamAuth() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var res = sharedPreferences.getString("tokenSystem");
    if(res == null) res = "";
    return res != "" ? HomePage() : SplashPage();
  }
}
