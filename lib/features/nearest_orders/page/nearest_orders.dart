import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marzy/features/standing_order/page/all_orders_courier.dart';
import 'package:marzy/features/static/basket/components/basket_button_item.dart';
import 'package:marzy/features/waiting_orders_detail/page/waiting_orders_detail.dart';
import 'package:marzy/shared/presentation/button_styles.dart';
import 'package:marzy/shared/widgets/custom_buttons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:marzy/shared/images/images.dart';
import 'package:marzy/shared/presentation/colors.dart';
import 'package:marzy/shared/presentation/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'nearest_order_item.dart';

class NearestOrdersPage extends StatefulWidget {
  static const route = '/nearest_orders';
  NearestOrdersPage({Key? key}) : super(key: key);

  @override
  _NearestOrdersPageState createState() => _NearestOrdersPageState();
}

class _NearestOrdersPageState extends State<NearestOrdersPage> with SingleTickerProviderStateMixin {
  late YandexMapController controller;
  GlobalKey mapKey = GlobalKey();
  bool stateMapCreated = true;
  late int _currentTab = 0;
  final List<MapObject> mapObjects = [];
  String location = "Определяем местоположение...";
  late TabController _tabController;
  var length;
  var latParam = 0.0;
  var lonParam = 0.0;
  var statusReq = "";
  late var idOrder = "11";
  late var priceForDelivery = "11";
  String? rate;
  var statusLoader = false;
  var resultDataForNextScreen;
  var visibilityBottomElement = false;
  var idDataForNextScreen;
  final MapObjectId cameraMapObjectId = MapObjectId('camera_placemark');
  final animation = MapAnimation(type: MapAnimationType.smooth, duration: 2.0);
  Future<bool> get locationPermissionNotGranted async => !(await Permission.location.request().isGranted);

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      getUserPosition();
    });
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToTab(int index) {
    _tabController.animateTo(index);
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => true);
      },
      child: FutureBuilder(
        future: getParamCourier(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.data == null) {
            return Scaffold(
              body: Container(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                  strokeWidth: 2,
                ),
              ),
            );
          }
          else if(snapshot.data == "0") {
            return Scaffold(
                appBar: AppBar(
                  title: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ваше местоположение"),
                        Text(
                          location,
                          style: TextStyle(
                              fontSize: 15
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(left: 5.w),
                  ),
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                ),
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(bottom: 55.h),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: CustomImage(
                      image: AppImages.locationUp,
                    ),
                    onPressed: () => getUserPosition(),
                  ),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    YandexMap(
                      key: mapKey,
                      mapObjects: mapObjects,
                      rotateGesturesEnabled: true,
                      onMapCreated: (YandexMapController yandexMapController) async {
                        controller = yandexMapController;
                        await controller.toggleUserLayer(
                            visible: true,
                            autoZoomEnabled: true
                        );
                      },
                      onCameraPositionChanged: (CameraPosition cameraPosition, CameraUpdateReason _, bool __) async {
                        print(await controller.getCameraPosition());
                        if(__) getLocationByCoordinate(cameraPosition.target.latitude, cameraPosition.target.longitude);
                        latParam = cameraPosition.target.latitude;
                        lonParam = cameraPosition.target.longitude;
                      },
                      onUserLocationAdded: (UserLocationView view) async {
                        getUserPosition();
                        return view.copyWith();
                      },
                    ),
                    CustomImage(
                      width: 100.w,
                      height: 100.w,
                      image: AppImages.locationUser,
                    ),
                  ],
                )
            );
          } else if(snapshot.data == "1") {
            return Scaffold(
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(bottom: 55.h),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: CustomImage(
                      image: AppImages.locationUp,
                    ),
                    onPressed: () => getUserPosition(),
                  ),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                bottomNavigationBar: Visibility(
                  visible: _currentTab == 1 ? true : false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 34.h),
                    child: Container(
                      height: 60.h,
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.fon,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                            future: getAllWaitingOrder(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if(snapshot.data == null) {
                                return Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.accent,
                                    strokeWidth: 2,
                                  ),
                                );
                              } else if(snapshot.data == "У вас нет заказов") {
                                return RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    text: 'У вас нет заказов',
                                    style:
                                    AppTextStyles.interMed14.copyWith(color: AppColors.black),
                                    children: [
                                      WidgetSpan(child: SizedBox(width: 4)),
                                    ],
                                  ),
                                );
                              } else {
                                return Row(
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: 'Ожидают доставки:',
                                        style:
                                        AppTextStyles.interMed14.copyWith(color: AppColors.black),
                                        children: [
                                          WidgetSpan(child: SizedBox(width: 4)),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: "1 заказ",
                                        style:
                                        AppTextStyles.interMed14.copyWith(color: AppColors.accent),
                                        children: [
                                          WidgetSpan(child: SizedBox(width: 4)),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AllOrdersPage(
                                                    idOrder: snapshot.data.id.toString(),
                                                    costCart: snapshot.data.deliveryCost.toString(),
                                                    snapshot: snapshot,
                                                )));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 11),
                                        // padding: EdgeInsets.only(bottom: 4.h, top: 12),
                                        child: Text(
                                          'перейти',
                                          style: AppTextStyles.interMed14.copyWith(
                                            color: AppColors.accent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                appBar: AppBar(
                  leadingWidth: 0.0,
                  titleSpacing: 0.0,
                  centerTitle: false,
                  title: Container(
                    margin: EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Ближайшие заказы"),
                        Text(
                          statusReq,
                          style: TextStyle(
                              fontSize: 15
                          ),
                        )
                      ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 22,
                              margin: EdgeInsets.only(right: 6),
                              child: ElevatedButton(
                                onPressed: () {
                                  _goToTab(0);
                                },
                                child: Text("Карта"),
                                style: _currentTab == 0
                                    ? ButtonStyles.tabItemBtnSelected
                                    : ButtonStyles.tabItemBtnUnSelected,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 22,
                              margin: EdgeInsets.only(right: 6),
                              child: ElevatedButton(
                                onPressed: () {
                                  _goToTab(1);
                                },
                                child: Text("Список"),
                                style: _currentTab == 1
                                    ? ButtonStyles.tabItemBtnSelected
                                    : ButtonStyles.tabItemBtnUnSelected,
                              ),
                            ),
                          ],
                        ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 133,
                    child: _currentTab == 0 ? Stack(
                      alignment: Alignment.center,
                      children: [
                        YandexMap(
                          key: mapKey,
                          mapObjects: mapObjects,
                          rotateGesturesEnabled: true,
                          onMapCreated: (YandexMapController yandexMapController) async {
                            controller = yandexMapController;
                            await controller.toggleUserLayer(
                                visible: true,
                                autoZoomEnabled: true
                            );
                          },
                          onCameraPositionChanged: (CameraPosition cameraPosition, CameraUpdateReason _, bool __) async {
                            print(await controller.getCameraPosition());
                            latParam = cameraPosition.target.latitude;
                            lonParam = cameraPosition.target.longitude;
                            if(__) {
                              setState(() => statusReq = "Вычисляем ближайшие заказы...");
                              Future.delayed(Duration(seconds: 2), () {
                                postReqGetAllOrdersFromStore().then((value) {
                                  var placeMark;

                                  if(value != null) {
                                    for(var i = 0; i < length; i++) {
                                      placeMark = PlacemarkMapObject(
                                        consumeTapEvents: true,
                                        onTap: (PlacemarkMapObject self, Point point) {
                                          setState(() {
                                            idDataForNextScreen = value[i];
                                            resultDataForNextScreen = value[i].deliveryCost;
                                            idOrder = value[i].id.toString();
                                            priceForDelivery = value[i].deliveryCost.toString();
                                            rate = "отрицательный";
                                            visibilityBottomElement = true;
                                          });
                                        },
                                        mapId: MapObjectId('placeMark_$i'),
                                        point: Point(
                                          latitude: double.parse(
                                              value[i].address!.geoLat!
                                          ),
                                          longitude: double.parse(
                                              value[i].address!.geoLon!
                                          ),
                                        ),
                                        icon: PlacemarkIcon.single(
                                            PlacemarkIconStyle(
                                              image: BitmapDescriptor.fromAssetImage('assets/images/img_1.png'),
                                            )
                                        ),
                                        opacity: 1.0,
                                      );

                                      setState(() {
                                        statusReq = "";
                                        mapObjects.removeWhere((el) => el.mapId == MapObjectId('placeMark_$i'));
                                        mapObjects.add(placeMark);
                                      });

                                      print('${value[i].address!.geoLat!}');
                                      print("placemark_$i");
                                    }
                                  }
                                });
                              });
                            }
                            if(__) getLocationByCoordinate(cameraPosition.target.latitude, cameraPosition.target.longitude);
                          },
                          onUserLocationAdded: (UserLocationView view) async {
                            getUserPosition();
                            setState(() => statusReq = "Вычисляем ближайшие заказы...");
                            Future.delayed(Duration(seconds: 2), () {
                              postReqGetAllOrdersFromStore().then((value) {
                                print("VALUE VALUE: $value");
                                print("LENGTH LENGTH: $length");

                                var placeMark;

                                if(value != null) {
                                  for(var i = 0; i < length; i++) {
                                    placeMark = PlacemarkMapObject(
                                      consumeTapEvents: true,
                                      onTap: (PlacemarkMapObject self, Point point) {
                                        setState(() {
                                          idDataForNextScreen = value[i];
                                          resultDataForNextScreen = value[i].deliveryCost;
                                          idOrder = value[i].id.toString();
                                          priceForDelivery = value[i].deliveryCost.toString();
                                          rate = "отрицательный";
                                          print("value[i]: ${value[i].productsCost}");
                                          print(idOrder);
                                          print(priceForDelivery);
                                          print(rate);
                                          visibilityBottomElement = true;
                                        });
                                      },
                                      mapId: MapObjectId('placeMark_$i'),
                                      point: Point(
                                        latitude: double.parse(
                                            value[i].address!.geoLat!
                                        ),
                                        longitude: double.parse(
                                            value[i].address!.geoLon!
                                        ),
                                      ),
                                      icon: PlacemarkIcon.single(
                                          PlacemarkIconStyle(
                                            image: BitmapDescriptor.fromAssetImage('assets/images/img_1.png'),
                                          )
                                      ),
                                      opacity: 1.0,
                                    );

                                    setState(() {
                                      statusReq = "";
                                      mapObjects.removeWhere((el) => el.mapId == MapObjectId('placeMark_$i'));
                                      mapObjects.add(placeMark);
                                    });

                                    print('${value[i].address!.geoLat!}');
                                    print("placemark_$i");
                                  }
                                }
                              });
                            });
                            return view.copyWith();
                          },
                        ),
                        CustomImage(
                          width: 100.w,
                          height: 100.w,
                          image: AppImages.locationUser,
                        ),
                        Visibility(
                          visible: visibilityBottomElement,
                          child: Positioned(
                            left: 20,
                            right: 20,
                            bottom: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                height: 185.h,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      width: 0.7,
                                      color: AppColors.fonGrey,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Действующий заказ: $idOrder',
                                            style:
                                            AppTextStyles.interMed14.copyWith(color: AppColors.black),
                                          ),
                                          CustomTextButton(
                                              text: 'перейти',
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => WaitingOrdersDetailPage(
                                                          id: idOrder,
                                                          priceCart: resultDataForNextScreen,
                                                          products: idDataForNextScreen,
                                                        )
                                                    )
                                                );
                                              }
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: 'Цена за доставку: ',
                                          style: AppTextStyles.interMed12,
                                          children: [
                                            WidgetSpan(child: SizedBox(width: 10)),
                                            TextSpan(
                                              text: '${priceForDelivery.toString()} ₽',
                                              style: AppTextStyles.interMed12.copyWith(
                                                color: AppColors.accent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: 'Рейтинг заказа: ',
                                          style: AppTextStyles.interMed12,
                                          children: [
                                            WidgetSpan(child: SizedBox(width: 10)),
                                            TextSpan(
                                              text: 'отрицательный',
                                              style: AppTextStyles.interMed12.copyWith(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      ElevatedButton(
                                          onPressed: () async {
                                            setState(() => statusLoader = true);
                                            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                            final String? action = sharedPreferences.getString('tokenSystem1');

                                            var response = await http.post(
                                              Uri.parse("https://marzy.ru/api/order/respond?order_id=$idOrder"),
                                              headers: {"Auth": action!},
                                            );

                                            setState(() => statusLoader = false);
                                            var result = utf8.decode(response.bodyBytes);
                                            print(result);
                                            final data = await json.decode(result);
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
                                                            "${data["message"]}",
                                                            style: AppTextStyles.interMed12.copyWith(fontSize: 15, color: AppColors.black)
                                                        ),
                                                        Container(
                                                          height: 10,
                                                        ),
                                                        BasketButtonItem(
                                                            buttonLabel: 'Закрыть',
                                                            backgroundColor: AppColors.accent,
                                                            textColor: AppColors.white,
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            }
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: statusLoader == false ? Text('Откликнуться') : Container(
                                            width: 17,
                                            height: 17,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          style: ButtonStyles.button1.copyWith(
                                            minimumSize: MaterialStateProperty.all(
                                              Size(double.infinity, 40),
                                            ),
                                          )
                                      ),
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  ),
                              ),
                            ),
                          ),
                        )),
                      ]
                    ) : Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                        child: ListView(
                          children: [
                            FutureBuilder(
                              future: postReqGetAllOrdersFromStore(),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                if(latParam == 0.0) {
                                  return Center(
                                    child: Container(
                                      margin: EdgeInsets.all(40),
                                      child: Text(
                                        "Вернитесь во вкладку «Карта» и определите Ваше местоположение"
                                      )
                                    ),
                                  );
                                } else if(snapshot.data == null) {
                                return Center(
                                  child: Container(
                                    margin: EdgeInsets.all(40),
                                    height: 55,
                                    width: 55,
                                    child: CircularProgressIndicator(
                                      color: AppColors.accent,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              } else {
                                if(length == 0) {
                                  return Container(
                                    child: Center(
                                      child: Text(
                                        "Поблизости нет доступных заказов"
                                      ),
                                    )
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      ListView.builder(
                                        itemCount: length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              NearestOrderItem(
                                                  id: snapshot.data[index].id.toString(),
                                                  rating: "отрицательный",
                                                  price: snapshot.data[index].deliveryCost,
                                                  listProducts: snapshot.data[index]
                                              ),
                                              Container(
                                                height: 10,
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ]
                                  );
                                }
                              }
                            },
                            )
                            // Container(
                            //   height: 165.h,
                            //   width: double.infinity,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(8),
                            //     border: Border.all(
                            //       color: AppColors.fonGrey,
                            //       width: 0.6,
                            //     ),
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           'Продуктовый заказ: 111',
                            //           style: AppTextStyles.interMed14
                            //               .copyWith(
                            //               color: AppColors.black,
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.w700
                            //           ),
                            //         ),
                            //         Row(
                            //           children: [
                            //             Text(
                            //               'Цена за доставку: ',
                            //               style: AppTextStyles.interMed12
                            //                   .copyWith(
                            //                   color: AppColors.black,
                            //                   fontSize: 14,
                            //                   fontWeight: FontWeight.w600
                            //               ),
                            //             ),
                            //             DivideItem(),
                            //             Text(
                            //               '343₽',
                            //               style: AppTextStyles.interMed12
                            //                   .copyWith(
                            //                   color: AppColors.accent,
                            //                   fontSize: 13,
                            //                   fontWeight: FontWeight.w600
                            //               ),
                            //             )
                            //           ],
                            //         ),
                            //         DivideItem(),
                            //         ElevatedButton(
                            //           onPressed: () {},
                            //           child: Text(AppStrings.respondToOrder),
                            //           style: ButtonStyles.button1.copyWith(
                            //             minimumSize:
                            //             MaterialStateProperty.all(Size(double.infinity, 50)),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    )
                  )
                ],
              )
            );
          }
          return Container();
        },
      )
    );
  }

  Future<List<Orders>?> postReqGetAllOrdersFromStore() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final String? action = sharedPreferences.getString('tokenSystem1');

      print("LAT PARAM: $latParam");
      print("LON PARAM: $lonParam");
      print("tokenSystem1: $action");

      var response = await http.get(
        Uri.parse("https://marzy.ru/api/order/get/free?lat=$latParam&lng=$lonParam"),
        headers: {
          "Auth": action!,
        },
      );

      var result = utf8.decode(response.bodyBytes);
      result = "[" + result.substring(0, result.length) + "]";
      final data = await json.decode(result);
      List<AllOrders> itemsList = List<AllOrders>.from(data.map((i) => AllOrders.fromJson(i)));
      length = itemsList[0].orders!.length;
      return itemsList[0].orders;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Object?> getAllWaitingOrder() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final String? action = sharedPreferences.getString('tokenSystem1');

      var response = await http.get(
        Uri.parse("https://marzy.ru/api/order/get/current"),
        headers: {
          "Auth": action!,
        },
      );

      var result = utf8.decode(response.bodyBytes);
      result = "[" + result.substring(0, result.length) + "]";
      final data = await json.decode(result);
      List<AllWaitingOrders> itemsList = List<AllWaitingOrders>.from(data.map((i) => AllWaitingOrders.fromJson(i)));

      if(itemsList[0].order == null) {
        return "У вас нет заказов";
      }
      if(itemsList[0].order!.status != null) return itemsList[0].order;
    } catch (e) {
      print("Ошибка при исполненеии: $e");
    }
    return null;
  }

  Future<String?> getParamCourier() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('paramUserType') == null ? "0" : sharedPreferences.getString('paramUserType');
  }

  Future<void> getUserPosition() async {
    var latitudeFromUser = 0.0;
    var longitudeFromUser = 0.0;
    if (await locationPermissionNotGranted) {
      return;
    }

    await controller.getUserCameraPosition().then((value) {
      print(value);
      latitudeFromUser = value!.target.latitude;
      longitudeFromUser = value.target.longitude;
    });

     print(await controller.getScreenPoint(Point(
         latitude: latitudeFromUser,
         longitude: longitudeFromUser
     )));

    await controller.moveCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
              target:  Point(
                latitude: latitudeFromUser,
                longitude: longitudeFromUser,
              )
            )
        ),
        animation: animation
    );

    getLocationByCoordinate(latitudeFromUser, longitudeFromUser);
  }

  Future<void> getLocationByCoordinate(double latitude, double longitude) async {
    final uri = Uri.parse('https://geocode-maps.yandex.ru/1.x/?'
        'apikey=c591eb6f-f764-4d4f-a971-48812779f158&geocode=$longitude,$latitude&format=json');

    var response = await http.get(uri);
    String responseBody = response.body;
    Map<String, dynamic> locationPickerMap = jsonDecode(response.body);
    var picker = LocationPicker.fromJson(locationPickerMap);
    print(responseBody);
    print(picker.response!.geoObjectCollection!.featureMember![0].geoObject!.metaDataProperty!.geocoderMetaData!.text);
    setState(() => location = picker.response!.geoObjectCollection!.featureMember![0].geoObject!.metaDataProperty!.geocoderMetaData!.text!);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("locationUser", location);
  }

  List<String> changeParamBottomBar() {
    return [
      idOrder,
      priceForDelivery
    ];
  }
}


class OrderTabList extends StatelessWidget {
  OrderTabList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NearestOrderItem(
              //   id: 'U223321',
              //   price: 343,
              //   rating: 'средний',
              // ),
              // NearestOrderItem(
              //   id: 'U223321',
              //   price: 343,
              //   rating: 'отрицательный',
              // ),
              // NearestOrderItem(
              //   id: 'U223321',
              //   price: 343,
              //   rating: 'положительный',
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 34.h),
        child: Container(
          height: 46.h,
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.fon,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: 'Ожидают доставки:',
                  style:
                      AppTextStyles.interMed14.copyWith(color: AppColors.black),
                  children: [
                    WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                      text: '2 заказа',
                      style: AppTextStyles.interMed14.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  // padding: EdgeInsets.only(bottom: 4.h, top: 12),
                  child: Text(
                    'перейти',
                    style: AppTextStyles.interMed14.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationPicker {
  Response? response;

  LocationPicker({this.response});

  LocationPicker.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  GeoObjectCollection? geoObjectCollection;

  Response({this.geoObjectCollection});

  Response.fromJson(Map<String, dynamic> json) {
    geoObjectCollection = json['GeoObjectCollection'] != null
        ? new GeoObjectCollection.fromJson(json['GeoObjectCollection'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geoObjectCollection != null) {
      data['GeoObjectCollection'] = this.geoObjectCollection!.toJson();
    }
    return data;
  }
}

class GeoObjectCollection {
  MetaDataProperty? metaDataProperty;
  List<FeatureMember>? featureMember;

  GeoObjectCollection({this.metaDataProperty, this.featureMember});

  GeoObjectCollection.fromJson(Map<String, dynamic> json) {
    metaDataProperty = json['metaDataProperty'] != null
        ? new MetaDataProperty.fromJson(json['metaDataProperty'])
        : null;
    if (json['featureMember'] != null) {
      featureMember = <FeatureMember>[];
      json['featureMember'].forEach((v) {
        featureMember!.add(new FeatureMember.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.featureMember != null) {
      data['featureMember'] =
          this.featureMember!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MetaDataProperty {
  GeocoderResponseMetaData? geocoderResponseMetaData;

  MetaDataProperty({this.geocoderResponseMetaData});

  MetaDataProperty.fromJson(Map<String, dynamic> json) {
    geocoderResponseMetaData = json['GeocoderResponseMetaData'] != null
        ? new GeocoderResponseMetaData.fromJson(
        json['GeocoderResponseMetaData'])
        : null;
  }

}

class GeocoderResponseMetaData {
  Point? point;
  String? request;
  String? results;
  String? found;

  GeocoderResponseMetaData(
      {this.point, this.request, this.results, this.found});

  GeocoderResponseMetaData.fromJson(Map<String, dynamic> json) {
    point = null;
    request = json['request'];
    results = json['results'];
    found = json['found'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.point != null) {
      data['Point'] = this.point!.toJson();
    }
    data['request'] = this.request;
    data['results'] = this.results;
    data['found'] = this.found;
    return data;
  }
}

class PointAdditional {
  String? pos;

  PointAdditional({this.pos});

  PointAdditional.fromJson(Map<String, dynamic> json) {
    pos = json['pos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pos'] = this.pos;
    return data;
  }
}

class FeatureMember {
  GeoObject? geoObject;

  FeatureMember({this.geoObject});

  FeatureMember.fromJson(Map<String, dynamic> json) {
    geoObject = json['GeoObject'] != null
        ? new GeoObject.fromJson(json['GeoObject'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geoObject != null) {
      data['GeoObject'] = this.geoObject!.toJson();
    }
    return data;
  }
}

class GeoObject {
  MetaDataPropertyAdditional? metaDataProperty;
  String? name;
  String? description;
  BoundedBy? boundedBy;
  Point? point;

  GeoObject(
      {this.metaDataProperty,
        this.name,
        this.description,
        this.boundedBy,
        this.point});

  GeoObject.fromJson(Map<String, dynamic> json) {
    metaDataProperty = json['metaDataProperty'] != null
        ? new MetaDataPropertyAdditional.fromJson(json['metaDataProperty'])
        : null;
    name = json['name'];
    description = json['description'];
    boundedBy = json['boundedBy'] != null
        ? new BoundedBy.fromJson(json['boundedBy'])
        : null;
    point = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.metaDataProperty != null) {
      data['metaDataProperty'] = this.metaDataProperty!.toJson();
    }
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.boundedBy != null) {
      data['boundedBy'] = this.boundedBy!.toJson();
    }
    if (this.point != null) {
      data['Point'] = this.point!.toJson();
    }
    return data;
  }
}

class MetaDataPropertyAdditional {
  GeocoderMetaData? geocoderMetaData;

  MetaDataPropertyAdditional({this.geocoderMetaData});

  MetaDataPropertyAdditional.fromJson(Map<String, dynamic> json) {
    geocoderMetaData = json['GeocoderMetaData'] != null
        ? new GeocoderMetaData.fromJson(json['GeocoderMetaData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geocoderMetaData != null) {
      data['GeocoderMetaData'] = this.geocoderMetaData!.toJson();
    }
    return data;
  }
}

class GeocoderMetaData {
  String? precision;
  String? text;
  String? kind;
  Address? address;
  AddressDetails? addressDetails;

  GeocoderMetaData(
      {this.precision,
        this.text,
        this.kind,
        this.address,
        this.addressDetails});

  GeocoderMetaData.fromJson(Map<String, dynamic> json) {
    precision = json['precision'];
    text = json['text'];
    kind = json['kind'];
    address =
    json['Address'] != null ? new Address.fromJson(json['Address']) : null;
    addressDetails = json['AddressDetails'] != null
        ? new AddressDetails.fromJson(json['AddressDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['precision'] = this.precision;
    data['text'] = this.text;
    data['kind'] = this.kind;
    if (this.address != null) {
      data['Address'] = this.address!.toJson();
    }
    if (this.addressDetails != null) {
      data['AddressDetails'] = this.addressDetails!.toJson();
    }
    return data;
  }
}

class Address {
  String? countryCode;
  String? formatted;
  List<Components>? components;

  Address({this.countryCode, this.formatted, this.components});

  Address.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    formatted = json['formatted'];
    if (json['Components'] != null) {
      components = <Components>[];
      json['Components'].forEach((v) {
        components!.add(new Components.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_code'] = this.countryCode;
    data['formatted'] = this.formatted;
    if (this.components != null) {
      data['Components'] = this.components!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Components {
  String? kind;
  String? name;

  Components({this.kind, this.name});

  Components.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['name'] = this.name;
    return data;
  }
}

class AddressDetails {
  Country? country;

  AddressDetails({this.country});

  AddressDetails.fromJson(Map<String, dynamic> json) {
    country =
    json['Country'] != null ? new Country.fromJson(json['Country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.country != null) {
      data['Country'] = this.country!.toJson();
    }
    return data;
  }
}

class Country {
  String? addressLine;
  String? countryNameCode;
  String? countryName;
  AdministrativeArea? administrativeArea;

  Country(
      {this.addressLine,
        this.countryNameCode,
        this.countryName,
        this.administrativeArea});

  Country.fromJson(Map<String, dynamic> json) {
    addressLine = json['AddressLine'];
    countryNameCode = json['CountryNameCode'];
    countryName = json['CountryName'];
    administrativeArea = json['AdministrativeArea'] != null
        ? new AdministrativeArea.fromJson(json['AdministrativeArea'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AddressLine'] = this.addressLine;
    data['CountryNameCode'] = this.countryNameCode;
    data['CountryName'] = this.countryName;
    if (this.administrativeArea != null) {
      data['AdministrativeArea'] = this.administrativeArea!.toJson();
    }
    return data;
  }
}

class AdministrativeArea {
  String? administrativeAreaName;
  SubAdministrativeArea? subAdministrativeArea;

  AdministrativeArea({this.administrativeAreaName, this.subAdministrativeArea});

  AdministrativeArea.fromJson(Map<String, dynamic> json) {
    administrativeAreaName = json['AdministrativeAreaName'];
    subAdministrativeArea = json['SubAdministrativeArea'] != null
        ? new SubAdministrativeArea.fromJson(json['SubAdministrativeArea'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AdministrativeAreaName'] = this.administrativeAreaName;
    if (this.subAdministrativeArea != null) {
      data['SubAdministrativeArea'] = this.subAdministrativeArea!.toJson();
    }
    return data;
  }
}

class SubAdministrativeArea {
  String? subAdministrativeAreaName;
  Locality? locality;

  SubAdministrativeArea({this.subAdministrativeAreaName, this.locality});

  SubAdministrativeArea.fromJson(Map<String, dynamic> json) {
    subAdministrativeAreaName = json['SubAdministrativeAreaName'];
    locality = json['Locality'] != null
        ? new Locality.fromJson(json['Locality'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SubAdministrativeAreaName'] = this.subAdministrativeAreaName;
    if (this.locality != null) {
      data['Locality'] = this.locality!.toJson();
    }
    return data;
  }
}

class Locality {
  String? localityName;
  DependentLocality? dependentLocality;

  Locality({this.localityName, this.dependentLocality});

  Locality.fromJson(Map<String, dynamic> json) {
    localityName = json['LocalityName'];
    dependentLocality = json['DependentLocality'] != null
        ? new DependentLocality.fromJson(json['DependentLocality'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LocalityName'] = this.localityName;
    if (this.dependentLocality != null) {
      data['DependentLocality'] = this.dependentLocality!.toJson();
    }
    return data;
  }
}

class DependentLocality {
  String? dependentLocalityName;
  Thoroughfare? thoroughfare;

  DependentLocality({this.dependentLocalityName, this.thoroughfare});

  DependentLocality.fromJson(Map<String, dynamic> json) {
    dependentLocalityName = json['DependentLocalityName'];
    thoroughfare = json['Thoroughfare'] != null
        ? new Thoroughfare.fromJson(json['Thoroughfare'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DependentLocalityName'] = this.dependentLocalityName;
    if (this.thoroughfare != null) {
      data['Thoroughfare'] = this.thoroughfare!.toJson();
    }
    return data;
  }
}

class Thoroughfare {
  String? thoroughfareName;
  Premise? premise;

  Thoroughfare({this.thoroughfareName, this.premise});

  Thoroughfare.fromJson(Map<String, dynamic> json) {
    thoroughfareName = json['ThoroughfareName'];
    premise =
    json['Premise'] != null ? new Premise.fromJson(json['Premise']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ThoroughfareName'] = this.thoroughfareName;
    if (this.premise != null) {
      data['Premise'] = this.premise!.toJson();
    }
    return data;
  }
}

class Premise {
  String? premiseNumber;

  Premise({this.premiseNumber});

  Premise.fromJson(Map<String, dynamic> json) {
    premiseNumber = json['PremiseNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PremiseNumber'] = this.premiseNumber;
    return data;
  }
}

class BoundedBy {
  Envelope? envelope;

  BoundedBy({this.envelope});

  BoundedBy.fromJson(Map<String, dynamic> json) {
    envelope = json['Envelope'] != null
        ? new Envelope.fromJson(json['Envelope'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.envelope != null) {
      data['Envelope'] = this.envelope!.toJson();
    }
    return data;
  }
}

class Envelope {
  String? lowerCorner;
  String? upperCorner;

  Envelope({this.lowerCorner, this.upperCorner});

  Envelope.fromJson(Map<String, dynamic> json) {
    lowerCorner = json['lowerCorner'];
    upperCorner = json['upperCorner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lowerCorner'] = this.lowerCorner;
    data['upperCorner'] = this.upperCorner;
    return data;
  }
}

class AllOrders {
  String? status;
  String? message;
  List<Orders>? orders;

  AllOrders({this.status, this.message, this.orders});

  AllOrders.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  num? id;
  num? clientId;
  num? memberId;
  List<Products>? products;
  num? deliveryCost;
  num? productsCost;
  num? allCost;
  String? status;
  AddressNearest? address;
  String? createDate;
  Null? finishDate;
  num? shopId;
  num? resultRating;
  String? resultComment;
  List<num>? responses;
  Shop? shop;

  Orders(
      {this.id,
        this.clientId,
        this.memberId,
        this.products,
        this.deliveryCost,
        this.productsCost,
        this.allCost,
        this.status,
        this.address,
        this.createDate,
        this.finishDate,
        this.shopId,
        this.resultRating,
        this.resultComment,
        this.responses,
        this.shop});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    memberId = json['member_id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    deliveryCost = json['delivery_cost'];
    productsCost = json['products_cost'];
    allCost = json['all_cost'];
    status = json['status'];
    address =
    json['address'] != null ? new AddressNearest.fromJson(json['address']) : null;
    createDate = json['create_date'];
    finishDate = json['finish_date'];
    shopId = json['shop_id'];
    resultRating = json['result_rating'];
    resultComment = json['result_comment'];
    responses = json['responses'].cast<num>();
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['member_id'] = this.memberId;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['delivery_cost'] = this.deliveryCost;
    data['products_cost'] = this.productsCost;
    data['all_cost'] = this.allCost;
    data['status'] = this.status;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['create_date'] = this.createDate;
    data['finish_date'] = this.finishDate;
    data['shop_id'] = this.shopId;
    data['result_rating'] = this.resultRating;
    data['result_comment'] = this.resultComment;
    data['responses'] = this.responses;
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    return data;
  }
}

class Products {
  num? count;
  Product? product;

  Products({this.count, this.product});

  Products.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  num? id;
  num? cost;
  String? name;
  String? unit;
  List<String>? photos;
  num? weight;
  String? article;
  num? shopId;
  num? categoryId;
  String? description;

  Product(
      {this.id,
        this.cost,
        this.name,
        this.unit,
        this.photos,
        this.weight,
        this.article,
        this.shopId,
        this.categoryId,
        this.description});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cost = json['cost'];
    name = json['name'];
    unit = json['unit'];
    weight = json['weight'];
    article = json['article'];
    shopId = json['shop_id'];
    photos = json['photos'].cast<String>();
    categoryId = json['category_id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cost'] = this.cost;
    data['name'] = this.name;
    data['unit'] = this.unit;
    data['weight'] = this.weight;
    data['photos'] = this.photos;
    data['article'] = this.article;
    data['shop_id'] = this.shopId;
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    return data;
  }
}

class Shop {
  num? id;
  String? name;
  String? description;
  String? photo;
  String? cityId;
  AddressNearest? address;

  Shop(
      {this.id,
        this.name,
        this.description,
        this.photo,
        this.cityId,
        this.address});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    photo = json['photo'];
    cityId = json['city_id'];
    address =
    json['address'] != null ? new AddressNearest.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['photo'] = this.photo;
    data['city_id'] = this.cityId;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class AddressNearest {
  int? qc;
  var area;
  var city;
  var flat;
  var block;
  var floor;
  var house;
  var metro;
  String? okato;
  String? oktmo;
  int? qcGeo;
  String? region;
  String? result;
  String? source;
  String? street;
  String? country;
  String? fiasId;
  String? geoLat;
  String? geoLon;
  var entrance;
  String? kladrId;
  int? qcHouse;
  String? timezone;
  var areaType;
  String? cityArea;
  var cityType;
  String? fiasCode;
  var flatArea;
  var flatType;
  var blockType;
  String? fiasLevel;
  var flatPrice;
  var houseType;
  var postalBox;
  var settlement;
  String? taxOffice;
  String? beltwayHit;
  String? postalCode;
  int? qcComplete;
  String? regionType;
  String? streetType;
  var areaFiasId;
  var cityFiasId;
  var flatFiasId;
  var areaKladrId;
  String? cityDistrict;
  var cityKladrId;
  var houseFiasId;
  var areaTypeFull;
  var areaWithType;
  String? capitalMarker;
  var cityTypeFull;
  var cityWithType;
  var flatTypeFull;
  var houseKladrId;
  String? regionFiasId;
  String? streetFiasId;
  var unparsedParts;
  var blockTypeFull;
  var houseTypeFull;
  String? regionIsoCode;
  String? regionKladrId;
  var settlementType;
  String? streetKladrId;
  var beltwayDistance;
  String? countryIsoCode;
  String? federalDistrict;
  String? regionTypeFull;
  String? regionWithType;
  String? streetTypeFull;
  String? streetWithType;
  String? taxOfficeLegal;
  String? cityDistrictType;
  var settlementFiasId;
  var squareMeterPrice;
  var settlementKladrId;
  String? fiasActualityState;
  var settlementTypeFull;
  var settlementWithType;
  var cityDistrictFiasId;
  var cityDistrictKladrId;
  String? cityDistrictTypeFull;
  String? cityDistrictWithType;

  AddressNearest(
      {this.qc,
        this.area,
        this.city,
        this.flat,
        this.block,
        this.floor,
        this.house,
        this.metro,
        this.okato,
        this.oktmo,
        this.qcGeo,
        this.region,
        this.result,
        this.source,
        this.street,
        this.country,
        this.fiasId,
        this.geoLat,
        this.geoLon,
        this.entrance,
        this.kladrId,
        this.qcHouse,
        this.timezone,
        this.areaType,
        this.cityArea,
        this.cityType,
        this.fiasCode,
        this.flatArea,
        this.flatType,
        this.blockType,
        this.fiasLevel,
        this.flatPrice,
        this.houseType,
        this.postalBox,
        this.settlement,
        this.taxOffice,
        this.beltwayHit,
        this.postalCode,
        this.qcComplete,
        this.regionType,
        this.streetType,
        this.areaFiasId,
        this.cityFiasId,
        this.flatFiasId,
        this.areaKladrId,
        this.cityDistrict,
        this.cityKladrId,
        this.houseFiasId,
        this.areaTypeFull,
        this.areaWithType,
        this.capitalMarker,
        this.cityTypeFull,
        this.cityWithType,
        this.flatTypeFull,
        this.houseKladrId,
        this.regionFiasId,
        this.streetFiasId,
        this.unparsedParts,
        this.blockTypeFull,
        this.houseTypeFull,
        this.regionIsoCode,
        this.regionKladrId,
        this.settlementType,
        this.streetKladrId,
        this.beltwayDistance,
        this.countryIsoCode,
        this.federalDistrict,
        this.regionTypeFull,
        this.regionWithType,
        this.streetTypeFull,
        this.streetWithType,
        this.taxOfficeLegal,
        this.cityDistrictType,
        this.settlementFiasId,
        this.squareMeterPrice,
        this.settlementKladrId,
        this.fiasActualityState,
        this.settlementTypeFull,
        this.settlementWithType,
        this.cityDistrictFiasId,
        this.cityDistrictKladrId,
        this.cityDistrictTypeFull,
        this.cityDistrictWithType});

  AddressNearest.fromJson(Map<String, dynamic> json) {
    qc = json['qc'];
    area = json['area'];
    city = json['city'];
    flat = json['flat'];
    block = json['block'];
    floor = json['floor'];
    house = json['house'];
    metro = json['metro'];
    okato = json['okato'];
    oktmo = json['oktmo'];
    qcGeo = json['qc_geo'];
    region = json['region'];
    result = json['result'];
    source = json['source'];
    street = json['street'];
    country = json['country'];
    fiasId = json['fias_id'];
    geoLat = json['geo_lat'];
    geoLon = json['geo_lon'];
    entrance = json['entrance'];
    kladrId = json['kladr_id'];
    qcHouse = json['qc_house'];
    timezone = json['timezone'];
    areaType = json['area_type'];
    cityArea = json['city_area'];
    cityType = json['city_type'];
    fiasCode = json['fias_code'];
    flatArea = json['flat_area'];
    flatType = json['flat_type'];
    blockType = json['block_type'];
    fiasLevel = json['fias_level'];
    flatPrice = json['flat_price'];
    houseType = json['house_type'];
    postalBox = json['postal_box'];
    settlement = json['settlement'];
    taxOffice = json['tax_office'];
    beltwayHit = json['beltway_hit'];
    postalCode = json['postal_code'];
    qcComplete = json['qc_complete'];
    regionType = json['region_type'];
    streetType = json['street_type'];
    areaFiasId = json['area_fias_id'];
    cityFiasId = json['city_fias_id'];
    flatFiasId = json['flat_fias_id'];
    areaKladrId = json['area_kladr_id'];
    cityDistrict = json['city_district'];
    cityKladrId = json['city_kladr_id'];
    houseFiasId = json['house_fias_id'];
    areaTypeFull = json['area_type_full'];
    areaWithType = json['area_with_type'];
    capitalMarker = json['capital_marker'];
    cityTypeFull = json['city_type_full'];
    cityWithType = json['city_with_type'];
    flatTypeFull = json['flat_type_full'];
    houseKladrId = json['house_kladr_id'];
    regionFiasId = json['region_fias_id'];
    streetFiasId = json['street_fias_id'];
    unparsedParts = json['unparsed_parts'];
    blockTypeFull = json['block_type_full'];
    houseTypeFull = json['house_type_full'];
    regionIsoCode = json['region_iso_code'];
    regionKladrId = json['region_kladr_id'];
    settlementType = json['settlement_type'];
    streetKladrId = json['street_kladr_id'];
    beltwayDistance = json['beltway_distance'];
    countryIsoCode = json['country_iso_code'];
    federalDistrict = json['federal_district'];
    regionTypeFull = json['region_type_full'];
    regionWithType = json['region_with_type'];
    streetTypeFull = json['street_type_full'];
    streetWithType = json['street_with_type'];
    taxOfficeLegal = json['tax_office_legal'];
    cityDistrictType = json['city_district_type'];
    settlementFiasId = json['settlement_fias_id'];
    squareMeterPrice = json['square_meter_price'];
    settlementKladrId = json['settlement_kladr_id'];
    fiasActualityState = json['fias_actuality_state'];
    settlementTypeFull = json['settlement_type_full'];
    settlementWithType = json['settlement_with_type'];
    cityDistrictFiasId = json['city_district_fias_id'];
    cityDistrictKladrId = json['city_district_kladr_id'];
    cityDistrictTypeFull = json['city_district_type_full'];
    cityDistrictWithType = json['city_district_with_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qc'] = this.qc;
    data['area'] = this.area;
    data['city'] = this.city;
    data['flat'] = this.flat;
    data['block'] = this.block;
    data['floor'] = this.floor;
    data['house'] = this.house;
    data['metro'] = this.metro;
    data['okato'] = this.okato;
    data['oktmo'] = this.oktmo;
    data['qc_geo'] = this.qcGeo;
    data['region'] = this.region;
    data['result'] = this.result;
    data['source'] = this.source;
    data['street'] = this.street;
    data['country'] = this.country;
    data['fias_id'] = this.fiasId;
    data['geo_lat'] = this.geoLat;
    data['geo_lon'] = this.geoLon;
    data['entrance'] = this.entrance;
    data['kladr_id'] = this.kladrId;
    data['qc_house'] = this.qcHouse;
    data['timezone'] = this.timezone;
    data['area_type'] = this.areaType;
    data['city_area'] = this.cityArea;
    data['city_type'] = this.cityType;
    data['fias_code'] = this.fiasCode;
    data['flat_area'] = this.flatArea;
    data['flat_type'] = this.flatType;
    data['block_type'] = this.blockType;
    data['fias_level'] = this.fiasLevel;
    data['flat_price'] = this.flatPrice;
    data['house_type'] = this.houseType;
    data['postal_box'] = this.postalBox;
    data['settlement'] = this.settlement;
    data['tax_office'] = this.taxOffice;
    data['beltway_hit'] = this.beltwayHit;
    data['postal_code'] = this.postalCode;
    data['qc_complete'] = this.qcComplete;
    data['region_type'] = this.regionType;
    data['street_type'] = this.streetType;
    data['area_fias_id'] = this.areaFiasId;
    data['city_fias_id'] = this.cityFiasId;
    data['flat_fias_id'] = this.flatFiasId;
    data['area_kladr_id'] = this.areaKladrId;
    data['city_district'] = this.cityDistrict;
    data['city_kladr_id'] = this.cityKladrId;
    data['house_fias_id'] = this.houseFiasId;
    data['area_type_full'] = this.areaTypeFull;
    data['area_with_type'] = this.areaWithType;
    data['capital_marker'] = this.capitalMarker;
    data['city_type_full'] = this.cityTypeFull;
    data['city_with_type'] = this.cityWithType;
    data['flat_type_full'] = this.flatTypeFull;
    data['house_kladr_id'] = this.houseKladrId;
    data['region_fias_id'] = this.regionFiasId;
    data['street_fias_id'] = this.streetFiasId;
    data['unparsed_parts'] = this.unparsedParts;
    data['block_type_full'] = this.blockTypeFull;
    data['house_type_full'] = this.houseTypeFull;
    data['region_iso_code'] = this.regionIsoCode;
    data['region_kladr_id'] = this.regionKladrId;
    data['settlement_type'] = this.settlementType;
    data['street_kladr_id'] = this.streetKladrId;
    data['beltway_distance'] = this.beltwayDistance;
    data['country_iso_code'] = this.countryIsoCode;
    data['federal_district'] = this.federalDistrict;
    data['region_type_full'] = this.regionTypeFull;
    data['region_with_type'] = this.regionWithType;
    data['street_type_full'] = this.streetTypeFull;
    data['street_with_type'] = this.streetWithType;
    data['tax_office_legal'] = this.taxOfficeLegal;
    data['city_district_type'] = this.cityDistrictType;
    data['settlement_fias_id'] = this.settlementFiasId;
    data['square_meter_price'] = this.squareMeterPrice;
    data['settlement_kladr_id'] = this.settlementKladrId;
    data['fias_actuality_state'] = this.fiasActualityState;
    data['settlement_type_full'] = this.settlementTypeFull;
    data['settlement_with_type'] = this.settlementWithType;
    data['city_district_fias_id'] = this.cityDistrictFiasId;
    data['city_district_kladr_id'] = this.cityDistrictKladrId;
    data['city_district_type_full'] = this.cityDistrictTypeFull;
    data['city_district_with_type'] = this.cityDistrictWithType;
    return data;
  }
}

class AllWaitingOrders {
  String? status;
  String? message;
  Order? order;

  AllWaitingOrders({this.status, this.message, this.order});

  AllWaitingOrders.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
  num? id;
  num? clientId;
  num? memberId;
  List<Products>? products;
  num? deliveryCost;
  num? productsCost;
  num? allCost;
  String? status;
  AddressDelivery? address;
  String? createDate;
  String? finishDate;
  num? shopId;
  num? resultRating;
  String? resultComment;
  List<num>? responses;
  Client? client;

  Order(
      {this.id,
        this.clientId,
        this.memberId,
        this.products,
        this.deliveryCost,
        this.productsCost,
        this.allCost,
        this.status,
        this.address,
        this.createDate,
        this.finishDate,
        this.shopId,
        this.resultRating,
        this.resultComment,
        this.responses,
        this.client});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    memberId = json['member_id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    deliveryCost = json['delivery_cost'];
    productsCost = json['products_cost'];
    allCost = json['all_cost'];
    status = json['status'];
    address =
    json['address'] != null ? new AddressDelivery.fromJson(json['address']) : null;
    createDate = json['create_date'];
    finishDate = json['finish_date'];
    shopId = json['shop_id'];
    resultRating = json['result_rating'];
    resultComment = json['result_comment'];
    responses = json['responses'].cast<int>();
    client = json['client'] != null ? new Client.fromJson(json['client']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['member_id'] = this.memberId;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['delivery_cost'] = this.deliveryCost;
    data['products_cost'] = this.productsCost;
    data['all_cost'] = this.allCost;
    data['status'] = this.status;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['create_date'] = this.createDate;
    data['finish_date'] = this.finishDate;
    data['shop_id'] = this.shopId;
    data['result_rating'] = this.resultRating;
    data['result_comment'] = this.resultComment;
    data['responses'] = this.responses;
    if (this.client != null) {
      data['client'] = this.client!.toJson();
    }
    return data;
  }
}

class AddressDelivery {
  String? geoLat;
  String? geoLon;

  AddressDelivery(
      {this.geoLat,
        this.geoLon});

  AddressDelivery.fromJson(Map<String, dynamic> json) {
    geoLat = json['geo_lat'];
    geoLon = json['geo_lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geo_lat'] = this.geoLat;
    data['geo_lon'] = this.geoLon;
    return data;
  }
}

class Client {
  String? name;
  String? surname;
  String? secondName;
  String? phone;

  Client({this.name, this.surname, this.secondName, this.phone});

  Client.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    secondName = json['second_name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['second_name'] = this.secondName;
    data['phone'] = this.phone;
    return data;
  }
}