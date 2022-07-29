import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/custom_navigation_button.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';

class OrderCommentScreen extends StatelessWidget {
  static const String route = '/order_comment';
  const OrderCommentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit');
    return Scaffold(
      // resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Комментарий'),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CustomBackButton(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CustomNavigationButton(
              image: 'assets/icons/checked.svg',
              width: 42.w,
              height: 42.w,
            ),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  disabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedErrorBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
                scrollPadding: EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                maxLines: 99,
                autofocus: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
