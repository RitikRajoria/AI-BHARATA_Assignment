import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/constants/const.dart';
import 'package:flutter_application_1/models/data_model.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';

import '../../pages/home.dart';

//functions and declarations
Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Random random = new Random();

ApiResponse? response;

// ui code for all widgets ==>

//bottom bar center button
Positioned bottomBarCenterButton(Size size) {
  return Positioned(
    bottom: 25,
    left: (size.width) * 0.42,
    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 4, color: Colors.black),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(Icons.swap_horiz, size: 32),
      ),
    ),
  );
}

//mainContainer
Widget mainContainer(Size size, BuildContext context, Stream<dynamic>? stream) {
  return ClipRRect(
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(42),
      bottomLeft: Radius.circular(42),
    ),
    child: Container(
      height: (size.height) * 0.897,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(42),
          bottomLeft: Radius.circular(42),
        ),
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != '{ "c" : "ok"}') {
              Map<String, dynamic> _snapshotData =
                  jsonDecode(snapshot.data as String);
              response = ApiResponse.fromJson(_snapshotData);
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: EdgeInsets.only(top: (size.height) * 0.4),
                child: Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data != '{ "c" : "ok"}' && snapshot.hasData) {
                return mainColumn(size, stream!);
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text('Connection Established'),
                    Padding(
                      padding: EdgeInsets.only(top: (size.height) * 0.4),
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else {
              return const Text('server side error');
            }
          },
        ),
      ),
    ),
  );
}

//mainColumn under stream builder
Column mainColumn(Size size, Stream<dynamic> stream) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      //profile bar
      profileBar(size),

      SizedBox(
        height: 20,
      ),

      //Favourite currencies
      favCoinWidget(size, stream),

      //all Coin data
      Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECOMMEND TO BUY',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            Icon(
              Icons.more_horiz_rounded,
              size: 26,
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),

      //all data
      Container(
        height: (size.height) * 5.57,
        child: recommendCardListView(size, response!),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );
}

//recommend cards ui
ListView recommendCardListView(Size size, ApiResponse response) {
  return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: response.data!.length,
      itemBuilder: (context, index) {
        final darkCardColor = darken(recommendCardColors[index], .1);
        final price = double.parse('${response.data![index].c}');
        final percentChange = double.parse('${response.data![index].P}');
        var priceFormat = NumberFormat("##,##,##,###.0#", "en_IN");
        final currentPrice = priceFormat.format(price);
        final percentageChangeFormatted = priceFormat.format(percentChange);

        final change = response.data![index].P;
        final changePrice = change![0];
        bool pnl = false;

        if (changePrice == "-") {
          pnl = false;
        } else {
          pnl = true;
        }

        return Padding(
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 6, bottom: 6),
          child: Container(
            height: (size.height) * 0.103,
            decoration: BoxDecoration(
              border: GradientBoxBorder(
                gradient: LinearGradient(
                  colors: [
                    darkCardColor,
                    recommendCardColors[index],
                    recommendCardColors[index],
                    darkCardColor
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.2, 0.4, 0.7, 0.9],
                ),
                width: 1,
              ),
              color: recommendCardColors[index],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/images/btc.png'),
                  ),
                  Container(
                    width: (size.width) * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${response.data![index].s}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          '${response.data![index].s}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.2),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.34,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${currentPrice}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        pnl
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_upward,
                                    size: 18,
                                    color: Colors.greenAccent.shade400,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '$percentageChangeFormatted%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.greenAccent.shade400,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_downward,
                                    size: 18,
                                    color: Colors.redAccent.shade400,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '$percentageChangeFormatted%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.redAccent.shade400,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

//fav cards widget
Container favCoinWidget(Size size, Stream<dynamic>? stream) {
  return Container(
    height: (size.height) * 0.34,
    width: size.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //fav text
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FAVORITE CURRENCIES',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
              Icon(
                Icons.more_horiz_rounded,
                size: 26,
              )
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),

        //listview builder
        Expanded(
          child: favcardListView(size, response!),
        ),

        SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}

//fav crds listview ui
ListView favcardListView(Size size, ApiResponse response) {
  return ListView.builder(
    physics: BouncingScrollPhysics(),
    scrollDirection: Axis.horizontal,
    itemCount: 6,
    itemBuilder: (context, index) {
      final price = double.parse('${response.data![index].c}');
      final percentChange = double.parse('${response.data![index].P}');
      var priceFormat = NumberFormat("##,##,##,###.0#", "en_IN");
      final currentPrice = priceFormat.format(price);
      final percentageChangeFormatted = priceFormat.format(percentChange);

      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: (size.width) * 0.37,
          decoration: BoxDecoration(
            color: cardColors[index],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${response.data![index].s}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1),
                      ),
                      Text(
                        '${response.data![index].s}',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.3), fontSize: 14),
                      ),
                      Chip(
                        backgroundColor: Colors.white,
                        label: Text(
                          '${percentageChangeFormatted}%',
                        ),
                      ),
                    ],
                  ),
                ),

                //chart
                Container(
                  height: (size.height) * 0.07,
                  child: LineChartWidget(),
                ),
                SizedBox(
                  height: 10,
                ),

                //icon and price
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: (size.height) * 0.045,
                        width: (size.width) * 0.088,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/images/btc.png'),
                      ),
                      Text(
                        '₹${currentPrice}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

//top profile bar ui under mainContainer
Container profileBar(Size size) {
  return Container(
    height: (size.height) * 0.3,
    width: size.width,
    decoration: BoxDecoration(
      color: Color(0xffB2C8DF),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(42),
        bottomRight: Radius.circular(42),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //avatar
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset('assets/images/pfp.png'),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WELCOME',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          width: (size.width) * 0.6,
                          child: Text(
                            'USERs NAME',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.notifications_none_outlined,
                  size: 28,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 20,
        ),

        //wallet balance
        Padding(
          padding: const EdgeInsets.only(left: 28, top: 10),
          child: Text(
            '  ₹ 4,18,000.569',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w500, letterSpacing: 1.1),
          ),
        ),

        SizedBox(
          height: 12,
        ),

        //buy and sell row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: Icon(Icons.add_circle_outline_outlined),
                ),
                Text(
                  'BUY',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    height: 0.2,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: Icon(Icons.remove_circle_outline_outlined),
                ),
                Text(
                  'SELL',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    height: 0.2,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Image.asset('assets/images/withdraw.png'),
                  ),
                ),
                Text(
                  'WITHDRAW',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    height: 0.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

//bottom app bar (only ui)
Positioned bottomBar(Size size) {
  return Positioned(
    bottom: 0,
    child: Container(
      padding: EdgeInsets.only(bottom: 16),
      height: (size.height) * 0.14,
      width: size.width,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Icon(Icons.home_rounded, color: Colors.white, size: 26),
          ),
          Container(
            child: Icon(Icons.account_balance_wallet,
                color: Colors.white.withOpacity(0.6), size: 26),
          ),
          SizedBox(width: 35),
          Container(
            child: Icon(Icons.business_center,
                color: Colors.white.withOpacity(0.6), size: 26),
          ),
          Container(
            child: Icon(
              Icons.person,
              color: Colors.white.withOpacity(0.6),
              size: 26,
            ),
          ),
        ],
      ),
    ),
  );
}
