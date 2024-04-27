import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kisaan_electric/AlertDialogBox/alertBoxContent.dart';
import 'package:kisaan_electric/global/appcolor.dart';
import 'package:kisaan_electric/products/controller/product_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../CartPage.dart';
import '../../Moddal/cartList.dart';
import '../../Moddal/productDetail.dart';
import '../../server/apiDomain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class detailedProductView extends StatefulWidget {
  final name;
  const detailedProductView({super.key, required this.name});

  @override
  State<detailedProductView> createState() => _detailedProductViewState(name);
}

class _detailedProductViewState extends State<detailedProductView> {
  int i = 0;
  productController controller = Get.put(productController());
  CarouselController buttonCarouselController = CarouselController();
  String selectedIndex = '';
  int _current = 0;
  var rating = 0.0;
  int quantity = 1;
  var sizeprice;
  bool _readMore = true;
  final name;
  var Price;
  var quantityprice;
  // var size = '';
  _detailedProductViewState(this.name);
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  CartListData() async {
    //   await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      final response = await http.post(Uri.parse('${apiDomain().domain}Cart'),
          headers: ({
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        print(productsData);
        CarList.Items = List.from(productsData)
            .map<CartData>((product) => CartData.fromJson(product))
            .toList();
        setState(() {});
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  var text =
      'Being  quality-conscious organization, we are instrument.Material- Galvanized Iron/ Mild Steel. Raw Material- TATA Steel \n Cable Entry- Side Entry';
  var checkdata = '';
  var idd = 0;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );
  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  List<String> sizeDataa = [];
  sizedBox(int name) async {
    //   await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var body = {"id": name};
    try {
      final response =
          await http.post(Uri.parse('${apiDomain().domain}productSize'),
              body: jsonEncode(body),
              headers: ({
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              }));
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data1"];
        // print('sa${productsData[0]}');
        //  for(int i = 0; i<productsData.length; i++){
        //    sizeDataa.add(productsData[i]);
        //  }

        productDataSize.Items = List.from(productsData)
            .map<Data1>((product) => Data1.fromJson(product))
            .toList();
        setState(() {});
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getConnectivity();
    SinglProductApi(name);
    sizedBox(name);
  }

  @override
  var value;
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(color: Colors.white),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              AppLocalizations.of(context)!.detail,
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.red,
                )),
            actions: [
              IconButton(
                  onPressed: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var data = prefs.getString('pro');
                    if (data == 'dealer') {
                      Get.off(demo());
                    }
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.red,
                  ))
            ],
          ),
          // drawer: customDrawer(),
          backgroundColor: Colors.transparent,
          // bottomNavigationBar: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Container(
          //         color: Colors.white,
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: appcolor.redColor
          //           ),
          //           onPressed: (){
          //             var value = {
          //               // "product_name":
          //             };
          //             api().Update('addToCart', value, context);
          //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Success')));
          //           },child: Text('Add to Cart', style: TextStyle(
          //           fontSize: 14,
          //           color: Colors.white,
          //           height: 0.7,
          //         ),),
          //         ),
          //       ),
          //       Container(
          //         color: Colors.white,
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //               backgroundColor: appcolor.redColor
          //           ),
          //
          //           onPressed: (){},child: Text('Order Place', style: TextStyle(
          //           fontSize: 14,
          //           color: Colors.white,
          //           height: 0.7,
          //         ),),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<productdetail>(
                    future: SinglProductApi(name),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Image.asset(apiDomain().nodataimage.toString());
                      } else if (snapshot.hasData) {
                        var data = snapshot.data;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: Get.height * 0.41,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Column(children: [
                                            CarouselSlider.builder(
                                                itemCount: data!.photos!.length,
                                                itemBuilder: (context, index,
                                                    realindex) {
                                                  final urlimage =
                                                      data.photos![index];
                                                  return Container(
                                                    width: Get.width,
                                                    color: Colors.grey,
                                                    child: Image.network(
                                                      '${apiDomain().imageUrl + urlimage.url.toString()}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                },
                                                options: CarouselOptions(
                                                    autoPlay: false,
                                                    height: 300,
                                                    enlargeCenterPage: false,
                                                    aspectRatio: 2.0,
                                                    viewportFraction: 1.0,
                                                    initialPage: 0,
                                                    onPageChanged:
                                                        (index, reason) {
                                                      setState(() {
                                                        _current = index;
                                                      });
                                                    })),
                                            Container(
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AnimatedSmoothIndicator(
                                                  activeIndex: _current,
                                                  count: data!.size!.length,
                                                  effect: JumpingDotEffect(
                                                      dotWidth: 8,
                                                      dotHeight: 8,
                                                      activeDotColor:
                                                          Colors.red,
                                                      dotColor: Colors.black12),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          // Column(
                                          //   children: [
                                          //
                                          //     Padding(
                                          //       padding: const EdgeInsets.all(4.0),
                                          //       child: Container(
                                          //         height: 50,
                                          //         width: 50,
                                          //         decoration: BoxDecoration(
                                          //           border: Border.all(color:_current != null ? Colors.red:Colors.black,width: 2)
                                          //         ),
                                          //         child:Image.asset('assets/image 16.png',fit: BoxFit.cover,)
                                          //
                                          //       ),
                                          //     ),
                                          //
                                          //     Padding(
                                          //       padding: const EdgeInsets.all(4.0),
                                          //       child: Container(
                                          //
                                          //         decoration: BoxDecoration(
                                          //
                                          //             border: Border.all(color:_current == null ? Colors.black:Colors.white,width: 2)
                                          //         ),
                                          //         child: Image(
                                          //
                                          //           image: AssetImage(
                                          //             'assets/image 16.png',
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     Padding(
                                          //       padding: const EdgeInsets.all(4.0),
                                          //       child: Container(
                                          //         decoration: BoxDecoration(
                                          //             border: Border.all(color:_current == null ? Colors.black:Colors.white,width: 2)
                                          //         ),
                                          //         child: Image(
                                          //           image: AssetImage(
                                          //             'assets/image 16.png',
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: Get.width * 0.9,
                                          child: Text(
                                            '${data!.product?.name.toString()}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                height: 1,
                                                fontWeight: FontWeight.w600),
                                            maxLines: 3,
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Text(
                                    //   'Rs. ${idd == 0? data.product!.price.toString():idd.toString()}',
                                    //   style: TextStyle(
                                    //     color: appcolor.newRedColor,
                                    //     fontSize: 14,
                                    //     height: 0.9,
                                    //   ),
                                    // ),
                                    // Container(
                                    //   height:20,
                                    //   child:
                                    // data.profession.toString() == 'dealer'?

                                    // ListView.builder(
                                    //   itemCount:productDataSize.Items.length,
                                    //     itemBuilder:(context, index){
                                    //     var sizepricedata = productDataSize.Items[index];
                                    //       sizeprice == sizepricedata.id?
                                    //       idd=sizepricedata.price!:'';
                                    //     // Text(
                                    //     //   '${sizepricedata.price}',
                                    //     //   style: TextStyle(
                                    //     //     color: appcolor.newRedColor,
                                    //     //     fontSize: 14,
                                    //     //     height: 0.9,
                                    //     //   ),
                                    //     // ):Text('');
                                    //   }
                                    //
                                    // ):Container(height: 0,width: 0,),
                                    //   ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.description,
                                      style: TextStyle(
                                          fontSize: 16,
                                          height: 0.9,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${data.product?.description}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 1.2,
                                          ),
                                          maxLines: _readMore ? 2 : 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  _onTapLink();
                                                },
                                                child: Text(
                                                  '${_readMore ? 'Read More' : 'Read Less'}',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.red),
                                                )),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .boxqty,
                                              style: TextStyle(
                                                  color: appcolor.redColor,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: 8,
                                              top: 3,
                                              left: 10,
                                              right: 10),
                                          width: Get.width * 0.45,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Color(
                                                0xffDD2B1C,
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: DropdownButtonFormField(
                                                isExpanded: true,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                  hintText: 'Selected Size',
                                                  hintStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    height: 1,
                                                  ),
                                                ),
                                                value: value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    sizeprice = value;
                                                  });
                                                },
                                                items: productDataSize.Items!
                                                    .map(
                                                        (e) => DropdownMenuItem(
                                                              child: Text(e.size
                                                                  .toString()),
                                                              value: e.id,
                                                            ))
                                                    .toList()),
                                          ),
                                        ),
                                        increasedecreasement()
                                      ],
                                    ),

                                    sizeprice != null
                                        ? FutureBuilder(
                                            future:
                                                sizeboxdata(name, sizeprice),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Text('No data found'),
                                                );
                                              } else if (snapshot.hasData) {
                                                var datasale = snapshot.data;
                                                var del = double.parse(
                                                        datasale['dealer_price']
                                                            .toString()) *
                                                    double.parse(
                                                        datasale['discount']) /
                                                    100;
                                                var netprice = double.parse(
                                                        datasale['dealer_price']
                                                            .toString()) -
                                                    del;
                                                quantityprice =
                                                    netprice * quantity;
                                                return Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .notifications,
                                                                style: TextStyle(
                                                                    color: appcolor
                                                                        .redColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                ' ${datasale['price']}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .code,
                                                                style: TextStyle(
                                                                    color: appcolor
                                                                        .redColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                " : ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              Text(
                                                                '${datasale['code']}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .dealer,
                                                                style: TextStyle(
                                                                    color: appcolor
                                                                        .redColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                " : ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              Text(
                                                                ' ${data.profession.toString() == 'dealer' ? datasale['dealer_price'] : ''}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .module,
                                                                style: TextStyle(
                                                                    color: appcolor
                                                                        .redColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                " :",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              Text(
                                                                '${datasale['module_size']}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .discount,
                                                                style: TextStyle(
                                                                    color: appcolor
                                                                        .redColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                "(%): ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              Text(
                                                                '${data.profession.toString() == 'dealer' ? '${datasale['discount']}' : ''}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .dimension,
                                                                style: TextStyle(
                                                                    color: appcolor
                                                                        .redColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                "(mm): ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              Text(
                                                                '${datasale['dimension']}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .netprice,
                                                                style: TextStyle(
                                                                    color: appcolor
                                                                        .redColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                "(Rs.): ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              Text(
                                                                ' ${data.profession.toString() == 'dealer' ? netprice : ''}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .cartoonbox,
                                                                style: TextStyle(
                                                                    color: appcolor
                                                                        .redColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                "(Pcs): ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              Text(
                                                                ' ${datasale['cartonpack']}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                );
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            })
                                        : Container(
                                            height: 0,
                                            width: 0,
                                          ),
                                    data.profession.toString() == 'dealer'
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .note,
                                                    style: TextStyle(
                                                        color:
                                                            appcolor.redColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    " : ",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .allpriceareincludingtaxes,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      11)),
                                                      width: Get.width * 0.9,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    appcolor
                                                                        .redColor),
                                                        onPressed: () {
                                                          var value = {
                                                            "id": name,
                                                            "quantity":
                                                                quantity,
                                                            "size": sizeprice,
                                                          };
                                                          if (sizeprice ==
                                                              null) {
                                                            alertBoxdialogBox(
                                                                context,
                                                                'Alert',
                                                                'Please Select Product Size');
                                                          } else {
                                                            api().Update(
                                                                'addToCart',
                                                                value,
                                                                context,
                                                                0);
                                                            setState(() {
                                                              CartListData();
                                                            });
                                                          }
                                                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Success')));
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .addtocart,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                            height: 0.7,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),

                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text('Additional Information',style: TextStyle(fontSize: 15,color: appcolor.redColor),),
                            //     SizedBox(height: 10,),
                            //     Row(
                            //       children: [
                            //         CircleAvatar(
                            //           backgroundColor: Colors.black,
                            //           radius: 4,
                            //         ),
                            //         SizedBox(
                            //           width: 10,
                            //         ),
                            //         Text(
                            //           'Material- Galvanized Iron/ Mild Steel',
                            //           style: TextStyle(
                            //             fontSize: 14,
                            //             height: 1,
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //     Row(
                            //       children: [
                            //         CircleAvatar(
                            //           backgroundColor: Colors.black,
                            //           radius: 4,
                            //         ),
                            //         SizedBox(
                            //           width: 10,
                            //         ),
                            //         Text(
                            //           'Raw Material- TATA Steel',
                            //           style: TextStyle(
                            //             fontSize: 14,
                            //             height: 1,
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //     Row(
                            //       children: [
                            //         CircleAvatar(
                            //           backgroundColor: Colors.black,
                            //           radius: 4,
                            //         ),
                            //         SizedBox(
                            //           width: 10,
                            //         ),
                            //         Text(
                            //           'Feature- Flame and Rust Proof',
                            //           style: TextStyle(
                            //             fontSize: 14,
                            //             height: 1,
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //     Row(
                            //       children: [
                            //         CircleAvatar(
                            //           backgroundColor: Colors.black,
                            //           radius: 4,
                            //         ),
                            //         SizedBox(
                            //           width: 10,
                            //         ),
                            //         Text(
                            //           'Dimensions- As per requirement',
                            //           style: TextStyle(
                            //             fontSize: 14,
                            //             height: 1,
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //     Row(
                            //       children: [
                            //         CircleAvatar(
                            //           backgroundColor: Colors.black,
                            //           radius: 4,
                            //         ),
                            //         SizedBox(
                            //           width: 10,
                            //         ),
                            //         Text(
                            //           'Cable Entry- Side Entry',
                            //           style: TextStyle(
                            //             fontSize: 14,
                            //             height: 1,
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //     SizedBox(height: 10,),
                            //
                            //
                            //   ],
                            // ),

                            // SmoothStarRating(
                            //     allowHalfRating: false,
                            //     onRatingChanged: (v) {
                            //       rating = v;
                            //       setState(() {});
                            //     },
                            //     starCount: 5,
                            //    rating: rating,
                            //     size: 40.0,
                            //     filledIconData: Icons.star,
                            //     halfFilledIconData: Icons.blur_on,
                            //     color: Colors.yellow,
                            //     borderColor: Colors.red,
                            //     spacing:0.0
                            // ),
                            // SizedBox(height: 10,),
                            // Container(
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       SizedBox(height: 8),
                            //       chartRow(context, '5', 89),
                            //       chartRow(context, '4', 70),
                            //       chartRow(context, '3', 40),
                            //       chartRow(context, '4', 10),
                            //       chartRow(context, '1', 0),
                            //       SizedBox(height: 8),
                            //     ],
                            //   ),
                            // ),
                            //         SizedBox(height: 20,),
                            // Container(
                            //   decoration: BoxDecoration(),
                            //   height: Get.height * 0.08,
                            //   child: TabBar(
                            //     dividerColor: appcolor.newRedColor,
                            //     isScrollable: true,
                            //     unselectedLabelColor: Colors.black,
                            //     unselectedLabelStyle: TextStyle(
                            //       fontSize: 14,
                            //     ),
                            //     indicatorColor: appcolor.redColor,
                            //     labelColor: Colors.black,
                            //     labelStyle: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.black,
                            //       fontSize: 14,
                            //     ),
                            //     controller: controller.tabcontroller,
                            //     tabs: [
                            //       Container(
                            //         child: Text(
                            //           'Description'.tr,
                            //         ),
                            //       ),
                            //       Container(
                            //         child: Text('Additional Information'.tr),
                            //       ),
                            //       Text('Review'.tr),
                            //     ],
                            //   ),
                            // ),
                            // Container(
                            //   height: Get.height * 0.15,
                            //   child: Expanded(
                            //     child: TabBarView(
                            //       controller: controller.tabcontroller,
                            //       children: [
                            //         Column(
                            //           children: [
                            //             SizedBox(
                            //               height: 10,
                            //             ),
                            //             Row(
                            //               children: [
                            //                 CircleAvatar(
                            //                   backgroundColor: Colors.black,
                            //                   radius: 4,
                            //                 ),
                            //                 SizedBox(
                            //                   width: 10,
                            //                 ),
                            //                 Text(
                            //                   'Material- Galvanized Iron/ Mild Steel',
                            //                   style: TextStyle(
                            //                     fontSize: 14,
                            //                     height: 1,
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //             Row(
                            //               children: [
                            //                 CircleAvatar(
                            //                   backgroundColor: Colors.black,
                            //                   radius: 4,
                            //                 ),
                            //                 SizedBox(
                            //                   width: 10,
                            //                 ),
                            //                 Text(
                            //                   'Raw Material- TATA Steel',
                            //                   style: TextStyle(
                            //                     fontSize: 14,
                            //                     height: 1,
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //             Row(
                            //               children: [
                            //                 CircleAvatar(
                            //                   backgroundColor: Colors.black,
                            //                   radius: 4,
                            //                 ),
                            //                 SizedBox(
                            //                   width: 10,
                            //                 ),
                            //                 Text(
                            //                   'Feature- Flame and Rust Proof',
                            //                   style: TextStyle(
                            //                     fontSize: 14,
                            //                     height: 1,
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //             Row(
                            //               children: [
                            //                 CircleAvatar(
                            //                   backgroundColor: Colors.black,
                            //                   radius: 4,
                            //                 ),
                            //                 SizedBox(
                            //                   width: 10,
                            //                 ),
                            //                 Text(
                            //                   'Dimensions- As per requirement',
                            //                   style: TextStyle(
                            //                     fontSize: 14,
                            //                     height: 1,
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //             Row(
                            //               children: [
                            //                 CircleAvatar(
                            //                   backgroundColor: Colors.black,
                            //                   radius: 4,
                            //                 ),
                            //                 SizedBox(
                            //                   width: 10,
                            //                 ),
                            //                 Text(
                            //                   'Cable Entry- Side Entry',
                            //                   style: TextStyle(
                            //                     fontSize: 14,
                            //                     height: 1,
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //         Center(child: Text('Information')),
                            //         Center(child: Text('Review')),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // Row(
                            //   children: [
                            //     GradientText(
                            //         gradient: appcolor.gradient,
                            //         widget: Text('Related Products', style: TextStyle(fontSize: 20,color: appcolor.redColor),)),
                            //   ],
                            // ),
                            // SizedBox(height: 10,),
                            // Wrap(
                            //   spacing: 10,
                            //   children: [
                            //     appItemWidget('assets/image 25.png'),
                            //     appItemWidget('assets/image 25.png'),
                            //     appItemWidget('assets/image 25.png'),
                            //   ],
                            // ),
                          ],
                        ).paddingSymmetric(horizontal: 10, vertical: 10);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget increasedecreasement() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          border: Border.all(color: appcolor.redColor, width: 1)),
      width: 120,
      height: 40,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  decrement();
                });
              },
              child: Padding(
                  padding: const EdgeInsets.only(right: 1.0),
                  child: Icon(
                    Icons.remove,
                    color: Colors.black,
                  )),
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              '$quantity',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 2,
            ),
            GestureDetector(
              onTap: () {
                increment();
              },
              child: Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget appItemWidget(
    String imagepath,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            bottom: 0,
          ),
          child: Image(
            image: AssetImage(
              imagepath,
            ),
          ),
        ),
        Container(
          child: Text(
            'Fan Round Box\n₹128.00 – ₹162.00',
            style: TextStyle(
              fontSize: 10,
              height: 0.9,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          decoration: BoxDecoration(
              color: appcolor.newRedColor,
              borderRadius: BorderRadius.circular(
                8,
              )),
          child: Text(
            'Buy Now',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              height: 0.7,
            ),
          ),
        ),
      ],
    );
  }

  void increment() {
    setState(() {
      quantity += 1;
    });
  }

  void decrement() {
    setState(() {
      if (quantity == 1) {
        quantity == 1;
      } else {
        quantity -= 1;
      }
    });
  }

  Widget chartRow(BuildContext context, String label, int pct) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: Colors.black)),
        SizedBox(width: 8),
        Icon(Icons.star, color: Colors.yellow),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.66,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(20)),
              child: Text(''),
            ),
            Container(
              width: MediaQuery.of(context).size.width * (pct / 100) * 0.66,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(20)),
              child: Text(''),
            ),
          ]),
        ),
        Text('$pct%', style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Future sizeboxdata(int body, value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var data = {"id": body, "size": value};
    final response =
        await http.post(Uri.parse('${apiDomain().domain}productDetailBySize'),
            body: jsonEncode(data),
            headers: ({
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }));
    if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
    if (response.statusCode == 200) {
      final catalogJson = response.body;
      print(response.statusCode);
      final decodedData = jsonDecode(catalogJson);
      // print('sadfasfasd$decodedData');
      return decodedData;
    }
  }

  Future<productdetail> SinglProductApi(int body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var data = {
      "id": body,
    };
    final response =
        await http.post(Uri.parse('${apiDomain().domain}productDetails'),
            body: jsonEncode(data),
            headers: ({
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }));
    if (response.statusCode == 404) {
      Get.offAll(apiDomain().login);
    }
    final catalogJson = response.body;
    print(response.statusCode);
    final decodedData = jsonDecode(catalogJson);
    print(decodedData);
    return productdetail.fromJson(decodedData);
  }

  double getTotal() {
    double total = 0.0;
    setState(() {
      CarList.Items.forEach((element) {
        total += (int.parse(element.price.toString()))! *
            (int.parse(element.quantity.toString()));
      });
    });
    setState(() {
      Price = double.parse('$total');
    });
    return total;
  }
}

class demo extends StatefulWidget {
  const demo({super.key});

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  CartListData() async {
    //   await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      final response = await http.post(Uri.parse('${apiDomain().domain}Cart'),
          headers: ({
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        print(productsData);
        CarList.Items = List.from(productsData)
            .map<CartData>((product) => CartData.fromJson(product))
            .toList();
        setState(() {});
      } else if (response.statusCode == 404) {
        Get.offAll(apiDomain().login);
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CartListData();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CartPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
