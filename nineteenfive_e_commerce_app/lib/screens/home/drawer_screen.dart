/// Drawer UI which includes user name, image and mail id,
/// app version in buttom of drawer,
/// Five options to navigate -> home, your profile, help & support, privacy policy and logout 

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nineteenfive_e_commerce_app/firebase/authentication/my_firebase_auth.dart';
import 'package:nineteenfive_e_commerce_app/screens/authentication/login_screen.dart';
import 'package:nineteenfive_e_commerce_app/screens/contact/help_and_support.dart';
import 'package:nineteenfive_e_commerce_app/screens/home/home_screen.dart';
import 'package:nineteenfive_e_commerce_app/screens/privacy_policy/privacy_policy.dart';
import 'package:nineteenfive_e_commerce_app/screens/user/your_profile.dart';
import 'package:nineteenfive_e_commerce_app/utils/color_palette.dart';
import 'package:nineteenfive_e_commerce_app/widgets/image/image_network.dart';
import 'package:nineteenfive_e_commerce_app/widgets/route/CustomPageRoute.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerScreen extends StatefulWidget {
  final Function(Widget) onChanged;
  final Function onDrawerClick;

  DrawerScreen({required this.onChanged, required this.onDrawerClick});

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  int selectedIndex = 0;

  // Custome widget for drawer tile
  getListTile(IconData iconData, String text, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(15)),
      child: Row(
        children: [
          Icon(
            iconData,
            color:
                selectedIndex == index ? ColorPalette.black : Colors.grey[600],
            size: ScreenUtil().setWidth(index == selectedIndex ? 26 : 24),
          ),
          SizedBox(width: ScreenUtil().setWidth(15)),
          Text(text,
              style: GoogleFonts.poppins(
                  color: selectedIndex == index
                      ? ColorPalette.black
                      : Colors.grey[600],
                  fontSize: selectedIndex == index ? 20.sp : 18.sp,
                  letterSpacing: 0.5,
                  fontWeight: selectedIndex == index
                      ? FontWeight.w600
                      : FontWeight.w500))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: ScreenUtil().setHeight(900),
        margin: EdgeInsets.only(right: ScreenUtil().setWidth(0)),
        padding: EdgeInsets.only(
            top: 10 + MediaQuery.of(context).padding.top,
            right: ScreenUtil().setWidth(160),
            left: 10,
            bottom: 10),
        decoration: const BoxDecoration(
          color: Color(0xfff6f5f5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                MyFirebaseAuth.firebaseAuth.currentUser != null &&
                        MyFirebaseAuth.firebaseAuth.currentUser!.photoURL !=
                            null
                    ? Container(
                        height: ScreenUtil().setWidth(60),
                        width: ScreenUtil().setWidth(60),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorPalette.lightGrey,
                        ),
                        child: ClipOval(
                          child: ImageNetwork(
                            width: ScreenUtil().setWidth(67),
                            height: ScreenUtil().setWidth(67),
                            fit: BoxFit.cover,
                            imageUrl: MyFirebaseAuth
                                    .firebaseAuth.currentUser!.photoURL ??
                                '',
                            errorIcon: CupertinoIcons.person_fill,
                          ),
                        ),
                      )
                    : Container(
                        height: ScreenUtil().setWidth(60),
                        width: ScreenUtil().setWidth(60),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorPalette.grey.withOpacity(0.2),
                        ),
                        child: Icon(
                          CupertinoIcons.person_fill,
                          size: ScreenUtil().setWidth(32),
                          color: ColorPalette.darkGrey,
                        ),
                      ),
                SizedBox(
                  width: ScreenUtil().setWidth(15),
                ),
                if (MyFirebaseAuth.firebaseAuth.currentUser != null)
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          MyFirebaseAuth
                                  .firebaseAuth.currentUser!.displayName ??
                              '',
                          style: Theme.of(context).textTheme.headline5,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          MyFirebaseAuth.firebaseAuth.currentUser!.email ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 16.sp,
                              color: ColorPalette.darkGrey),
                        )
                      ],
                    ),
                  )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                GestureDetector(
                  onTap: () {
                    selectedIndex = 0;
                    widget.onChanged.call(HomeScreen(
                      onDrawerClick: () => widget.onDrawerClick.call(),
                    ));
                  },
                  child: getListTile(CupertinoIcons.house, 'Home', 0),
                ),
                GestureDetector(
                    onTap: () {
                      selectedIndex = 1;
                      widget.onChanged.call(YourProfile(
                        onDrawerClick: widget.onDrawerClick,
                      ));
                    },
                    child:
                        getListTile(CupertinoIcons.person, 'Your Profile', 1)),
                GestureDetector(
                    onTap: () {
                      selectedIndex = 4;
                      widget.onChanged.call(HelpAndSupport(
                        onDrawerClick: widget.onDrawerClick,
                      ));
                    },
                    child: getListTile(Icons.headset, 'Help & Support', 4)),
                GestureDetector(
                  onTap: () {
                    selectedIndex = 6;
                    widget.onChanged.call(PrivacyPolicyScreen(
                      onDrawerClick: widget.onDrawerClick,
                    ));
                  },
                  child:
                      getListTile(Icons.bookmark_border, 'Privacy Policy', 6),
                ),
                GestureDetector(
                    onTap: () {
                      GoogleSignIn().disconnect();
                      MyFirebaseAuth.firebaseAuth.signOut();
                      Navigator.pushReplacement(
                          context,
                          CustomPageRoute(
                              widget: LoginScreen(),
                              curve: Curves.easeOutExpo));
                    },
                    child: getListTile(Icons.logout, 'Logout', 8))
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
              child: Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
