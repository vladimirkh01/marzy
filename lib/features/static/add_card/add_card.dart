import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCardScreen extends StatelessWidget {
  static const String route = '/add_card';
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddCardScreenAdditional();
  }
}

class AddCardScreenAdditional extends StatefulWidget {
  const AddCardScreenAdditional({Key? key}) : super(key: key);

  @override
  State<AddCardScreenAdditional> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreenAdditional> {
  String _imagePayment = AppImages.paymentVisa;
  late String _cardNumber;
  late String _cardTerm;
  late String _cardSecurityCode;
  bool _statusVisibilityImagePayment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        title: Text('Добавить карту'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 38.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 0.0),
              child: Text(
                'Номер карты',
                style: AppTextStyles.interMed12,
              ),
            ),
            SizedBox(height: 4.h),
            TextFormField(
              onChanged: (text) {
                setState(() {
                  _cardNumber = text;
                  if(text == "") {
                    _statusVisibilityImagePayment = false;
                    _imagePayment = AppImages.paymentVisa;
                  } else if(text[0] == "4") {
                    _statusVisibilityImagePayment = true;
                    _imagePayment = AppImages.paymentVisa;
                  } else if(text[0] == "2") {
                    _statusVisibilityImagePayment = true;
                    _imagePayment = AppImages.paymentMIR;
                  } else if(text[0] == "5") {
                    _statusVisibilityImagePayment = true;
                    _imagePayment = AppImages.payment;
                  }
                });
              },
              decoration: _statusVisibilityImagePayment ? InputDecoration(
                  hintText: 'Введите номер карты',
                  icon: Visibility(
                    visible: _statusVisibilityImagePayment,
                    child: Container(
                      width: 35,
                      height: 35,
                      child: CustomImage(
                        image: _imagePayment,
                      ),
                    ),
                  )
              ) : InputDecoration(
                  hintText: 'Введите номер карты'
              )
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Срок карты',
                    style: AppTextStyles.interMed12,
                  ),
                ),
                Expanded(
                  child: Text(
                    'CVV',
                    style: AppTextStyles.interMed12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (text) => _cardTerm = text,
                    decoration: InputDecoration(
                      hintText: 'Введите срок карты',
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: TextFormField(
                    onChanged: (text) => _cardSecurityCode = text,
                    decoration: InputDecoration(hintText: 'Введите CVV код'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              'Ваша платежная информация\nнадежно защищена',
              style: AppTextStyles.interReg14.copyWith(height: 1.7),
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, 40.h),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                child: GestureDetector(
                    onTap: () async {
                      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                      print(sharedPreferences.getString("cardNumber1"));
                      print(sharedPreferences.getString("cardNumber2"));
                      print(sharedPreferences.getString("cardNumber3"));
                      if(sharedPreferences.getString("cardNumber1") == "") {
                        sharedPreferences.setString("cardNumber1", _cardNumber);
                        sharedPreferences.setString("cardTerm1", _cardTerm);
                        sharedPreferences.setString("cardSecurityCode1", _cardSecurityCode);
                        print(sharedPreferences.getString("cardNumber1"));
                      } else if(sharedPreferences.getString("cardNumber2") == "") {
                        sharedPreferences.setString("cardNumber2", _cardNumber);
                        sharedPreferences.setString("cardTerm2", _cardTerm);
                        sharedPreferences.setString("cardSecurityCode2", _cardSecurityCode);
                        print(sharedPreferences.getString("cardNumber2"));
                      } else if(sharedPreferences.getString("cardNumber3") == "") {
                        sharedPreferences.setString("cardNumber3", _cardNumber);
                        sharedPreferences.setString("cardTerm3", _cardTerm);
                        sharedPreferences.setString("cardSecurityCode3", _cardSecurityCode);
                        print(sharedPreferences.getString("cardNumber3"));
                      }
                    },
                    child: Text(
                      'Подтвердить',
                      style:
                      AppTextStyles.interMed14.copyWith(color: AppColors.white),
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}

