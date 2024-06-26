/// Change password screen UI.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../firebase/authentication/my_firebase_auth.dart';
import '../../widgets/button/long_blue_button.dart';
import '../../widgets/dialog/my_dialog.dart';
import '../../widgets/text field/basic_text_field.dart'; 

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();


  // textfield validation 
  Future<void> validate(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      bool result = await MyFirebaseAuth(context)
          .updatePassword(oldPasswordController.text, newPasswordController.text);
      if(result) {
        Navigator.pop(context);
        Navigator.pop(context);
        await MyDialog.showMyDialog(context, 'Password Updated');
      }

    }
  }

  // password textfield validation string
  String? passwordValidator(value) {
    if (value.isEmpty)
      return "Required *";
    else if (value.length < 6)
      return "Should be at least 6 characters";
    else if (value.length > 15)
      return "Should not be more than 15 characters";
    else
      return null;
  }

  // confirm password textfield validation string
  String? confirmPasswordValidator(value) {
    if(value.isEmpty) {
      return "Required *";
    }
    else if (newPasswordController.text != value)
      return "Confirm password not matched..!";
    else
      return null;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                Navigator.pop(context);
              }),
          title: Text('Change Password',
              style: Theme.of(context).textTheme.headline2),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BasicTextField(
                    labelText: 'Old Password',
                    obscureText: true,
                    controller: oldPasswordController,
                    validator: passwordValidator,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  BasicTextField(
                    labelText: 'New Password',
                    validator: passwordValidator,
                    obscureText: true,
                    controller: newPasswordController,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  BasicTextField(
                    labelText: 'Confirm Password',
                    validator: confirmPasswordValidator,
                    obscureText: true,
                    controller: newConfirmPasswordController,
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                  ),
                  LongBlueButton(
                    text: 'Update Password',
                    onPressed: () => validate(context),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),

                ],
              ),
            ),
          ),
        ));
  }
}
