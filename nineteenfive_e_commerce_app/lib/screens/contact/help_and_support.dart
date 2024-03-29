/// Help & Support UI screen
/// Two ways to contact -> chat with us and email us  

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nineteenfive_e_commerce_app/utils/color_palette.dart';
import 'package:nineteenfive_e_commerce_app/utils/constants.dart';
import 'package:nineteenfive_e_commerce_app/widgets/dialog/my_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatefulWidget {
  final Function onDrawerClick;

  HelpAndSupport({required this.onDrawerClick});

  @override
  _HelpAndSupportState createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {

  // on click email us open native mail 
  sendMail() async {
    const url = 'mailto:${Constants.ADMIN_MAIL_ID}';
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      MyDialog.showMyDialog(context, "Could not launch mail id..!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: ScreenUtil().setWidth(25),
            ),
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              widget.onDrawerClick();
            }
          },
        ),
        title: Text('Help & Support',
            style: Theme.of(context).textTheme.headline2),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            await widget.onDrawerClick();
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(790),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/icons/headphones.png',
                      width: ScreenUtil().setWidth(150),
                    ),
                    Text(
                      'How can we help you ?',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => ChatScreen()));
                      },
                      child: Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(80),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: ColorPalette.blue,
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().radius(17))),
                        child: Row(
                          children: [
                            SizedBox(
                              width: ScreenUtil().setWidth(30),
                            ),
                            Image.asset(
                              'assets/icons/chat.png',
                              width: ScreenUtil().setWidth(30),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(20),
                            ),
                            Text('Chat with us',
                                style: Theme.of(context).textTheme.headline3),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMail();
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => EmailUs()));
                      },
                      child: Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(80),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: ColorPalette.lightGrey,
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().radius(18))),
                        child: Row(
                          children: [
                            SizedBox(
                              width: ScreenUtil().setWidth(30),
                            ),
                            Image.asset(
                              'assets/icons/mail.png',
                              width: ScreenUtil().setWidth(30),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(20),
                            ),
                            Text('Email us',
                                style: Theme.of(context).textTheme.headline3),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
