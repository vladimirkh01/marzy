import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marzy/features/auth/sing_up/providers/sing_up_provider.dart';
import 'package:marzy/features/home/page/home.dart';
import 'package:marzy/features/splash/views/splash.dart';

class SingUpMap extends StatelessWidget {
  final SingUpProvider provider;
  SingUpMap({
    Key? key,
    required this.provider,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SplashPage()));
    });
    return Center(
      child: Container(
        child: Text(
          "Регистрация успешно завершена!"
        ),
      ),
    );
  }
}
