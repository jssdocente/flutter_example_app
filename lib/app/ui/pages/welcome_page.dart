import 'package:apnapp/app/ui/widgets/_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buidBackground(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    var th = Theme.of(context);

    //var style = MyTheme.text.headline4.merge(TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800));
    //var style2 = MyTheme.text.headline4.merge(TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w800,fontSize: 36));

    var style = th.textTheme.headline4.merge(TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w800));
    var style2 = th.textTheme.headline4.merge(TextStyle(fontFamily: "Roboto", fontWeight: FontWeight.w800, fontSize: 36));

    return Container(
      height: size.height,
      width: size.width,
      //color: Colors.black12.withOpacity(0.2),
      color: th.splashColor,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: size.height * 0.15,
            left: size.width * 0.10,
            right: 10,
            child: Opacity(
              opacity: 0.9,
              child: Image(
                image: AssetImage('assets/images/WelcomeAmbulance.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.12),
          Positioned(
            bottom: size.height * 0.10,
            left: size.width * 0.10,
            //right: size.width * 0.60,
            child: RoundedButton(
              text: "INCIAR SESIÓN",
              press: () {
                Get.off('/login');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buidBackground(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
//        Positioned(
//          top: 0,
//          left: 0,
//          child: Image.asset(
//            "assets/images/main_top.png",
//            width: size.width * 0.3,
//          ),
//        ),
//        Positioned(
//          bottom: 0,
//          left: 0,
//          child: Image.asset(
//            "assets/images/main_bottom.png",
//            width: size.width * 0.2,
//          ),
//        ),
          _buildBody(context),
        ],
      ),
    );
  }
}

