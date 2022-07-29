import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:marzy/features/auth/verification/providers/verification_provider.dart';
import 'package:marzy/features/home/page/home.dart';
import 'package:marzy/features/static/basket/components/basket_button_item.dart';
import 'package:marzy/shared/alerts/alerts.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/localization/strings_ru.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  var result = 250;
  var _statusLoader = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VerificationProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.verification),
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Builder(
            builder: (BuildContext context) {
              final provider = context.watch<VerificationProvider>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 42.h,
                  ),
                  Text(
                    AppStrings.verificationText,
                    style: AppTextStyles.interMed12,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  _PassportImage(provider: provider),
                  SizedBox(
                    height: 12.h,
                  ),
                  _SelfiImage(provider: provider),
                  SizedBox(
                    height: 52.h,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var uuid = Uuid();
                      setState(() => _statusLoader = true);
                      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                      final String? action = sharedPreferences.getString('tokenSystem');
                      List<int> imageBytes = provider.passportSelfie!.readAsBytesSync();
                      String base64Image = base64Encode(imageBytes);
                      Map data = {
                        'filename': '$uuid.jpg',
                        'file': 'data:image/jpeg;base64,$base64Image'
                      };

                      var body = json.encode(data);
                      var response = await Dio().post(
                        "https://marzy.ru/api/files/upload/json",
                        queryParameters: {"Content-Type": "application/json"},
                        data: body,
                        // onSendProgress: (int sent, int total) {
                        //   final progress = sent / total;
                        //   print('progress: ${progress * 250}');
                        // },
                      );

                      var res1 = response.data["uuid"];
                      print("UUID PASSPORT SELFIE: ${response.data["uuid"]}");
                      uuid = Uuid();
                      List<int> imageBytes1 = provider.passportImage!.readAsBytesSync();
                      String base64Image1 = base64Encode(imageBytes1);

                      data = {
                        'filename': '$uuid.jpg',
                        'file': 'data:image/jpeg;base64,$base64Image1'
                      };

                      body = json.encode(data);

                      response = await Dio().post(
                          "https://marzy.ru/api/files/upload/json",
                          queryParameters: {"Content-Type": "application/json"},
                          data: body
                      );

                      var res2 = response.data["uuid"];
                      print("UUID PASSPORT IMAGE: ${response.data["uuid"]}");

                      var response2 = await http.get(
                          Uri.parse("https://marzy.ru/api/user/passport/load?uuid=$res2"),
                          headers: {"Auth": action!}
                      );

                      print(response2.body);

                      response2 = await http.get(
                          Uri.parse("https://marzy.ru/api/user/selfie/load?uuid=$res1"),
                          headers: {"Auth": action}
                      );

                      print(response2.body);
                      setState(() => _statusLoader = false);

                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              height: 300,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(top: 30),
                                    child: Image.asset(AppImages.paid),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                      "Ваши документы проверяют",
                                      style: AppTextStyles.interMed12.copyWith(fontSize: 15, color: AppColors.black)
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  BasketButtonItem(
                                      buttonLabel: 'Завершить',
                                      backgroundColor: AppColors.accent,
                                      textColor: AppColors.white,
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage()));
                                      }
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: _statusLoader ? Container(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    ) : Text(AppStrings.continue2),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SelfiImage extends StatelessWidget {
  final VerificationProvider provider;
  const _SelfiImage({
    Key? key,
    required this.provider
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (provider.passportSelfie == null) {
      return ElevatedButton(
        style: ButtonStyles.button2,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ImageAlert(
                onImageSelected: (value) {
                  provider.setPassportSelfie(value);
                },
              );
            },
          );
        },
        child: Text(AppStrings.selfiPastpost),
      );
    }
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.fonGrey,
      ),
      child: Row(
        children: [
          Expanded(
            child: _ImageProgress(
                right: 0,
            ),
          ),
          SizedBox(width: 20),
          Container(
            alignment: Alignment.centerRight,
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: FileImage(provider.passportSelfie!),
                    fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PassportImage extends StatelessWidget {
  final VerificationProvider provider;
  const _PassportImage({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (provider.passportImage == null) {
      return ElevatedButton(
        style: ButtonStyles.button2,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ImageAlert(
                onImageSelected: (value) {
                  provider.setPassportImage(value);
                },
              );
            },
          );
        },
        child: Text(AppStrings.passportImage),
      );
    }
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.fonGrey,
      ),
      child: Row(
        children: [
          Text(AppStrings.passportImage),
          SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: FileImage(provider.passportImage!),
                    fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageProgress extends StatelessWidget {
  double right;
  _ImageProgress({Key? key, required this.right}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppStrings.selfiPastpost),
        SizedBox(height: 16.h),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.blackGrey,
              ),
              height: 5,
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              right: right,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.accent,
                ),
                height: 5,
              ),
            ),
          ],
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
