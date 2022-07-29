import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marzy/features/order_pub/order_courier.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../home/page/home.dart';

class CourierItem extends StatelessWidget {
 final String nameCourier;
 final String rateValue;
 final String idCourier;
 final String idOrder;

  CourierItem({
    Key? key,
    required this.nameCourier,
    required this.rateValue,
    required this.idCourier,
    required this.idOrder
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 0.4,
          color: AppColors.fonGrey,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 63.h,
                  width: 63.w,
                  decoration: BoxDecoration(
                    color: AppColors.fonGrey,
                    borderRadius: BorderRadius.circular(70),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: 19.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '$nameCourier',
                        style: AppTextStyles.interReg16,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Рейтинг: $rateValue',
                        style: AppTextStyles.interMed12
                            .copyWith(color: AppColors.blackGrey),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 4),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderCourierPage(idCourierFrom: int.parse(idCourier))));
                  },
                  icon: Icon(Icons.more_horiz),
                  color: AppColors.blackGrey,
                )
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => chooseCourier(idOrder, idCourier, context),
              child: Text('Выбрать курьера'),
              style: ButtonStyles.button1.copyWith(
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 46)),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Future<void> chooseCourier(String orderId, String memberId, BuildContext context) async {
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   final String? action = sharedPreferences.getString('tokenSystem');

   try {
     var response = await http.post(
       Uri.parse("https://marzy.ru/api/order/submit?order_id=$orderId&member_id=$memberId"),
       headers: {
         "Auth": action!,
       },
     );

     var result = utf8.decode(response.bodyBytes);
     result = result.substring(0, result.length);
     final data = await json.decode(result);

     showModalBottomSheet(
       isScrollControlled: true,
       context: context,
       backgroundColor: Colors.transparent,
       builder: (BuildContext bc) {
         return Container(
           width: MediaQuery.of(context).size.width,
           height: 120,
           child: Container(
             padding: const EdgeInsets.all(20),
             decoration: new BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   "${data["message"]}",
                   style: AppTextStyles.interReg16,
                 )
               ],
             ),
           )
         );
       },
     ).whenComplete(() => {
     Navigator.push(
      context, MaterialPageRoute(builder: (context) => HomePage())
     )});
   } catch (e) {
     print("При попытке ошибка: $e");
   }
 }

}
