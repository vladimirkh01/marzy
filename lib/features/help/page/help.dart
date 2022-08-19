import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';

class HelpScreen extends StatelessWidget {
  static const String route = '/help';
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CustomBackButton(),
        ),
        title: Text('Поддержка'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 10.h,
          ),
          child: Column(
              children: <Widget>[
                FutureBuilder(
                  future: _getText(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.data != null) {
                      return Text(
                        snapshot.data
                      );
                    }

                    return Container();
                  },
                )
              ]
          ),
        ),
      ),
    );
  }

  Future<String?> _getText() async {
    String? text;
    try {
      text = await rootBundle.loadString("assets/icons/text.txt");
    } catch (e) {
      print("Couldn't read file $e");
    }
    return text;
  }
}
