import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppWidgets {
  static Widget userInputField(
      {String? hintText,
      TextEditingController? controller,
      FocusNode? focusNode,
      InputDecoration? decoration,
      String? Function(String?)? validator,
      List<TextInputFormatter>? inputFormatters,
      TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        key: ValueKey(hintText),
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        onTap: () {
          if (focusNode != null && focusNode.hasFocus == false) {
            focusNode.requestFocus();
          }
        },
        onTapOutside: (pointerDownEvent){
          if (focusNode != null && focusNode.hasFocus == true) {
            focusNode.unfocus();
          }
        },
        onEditingComplete: () {
          if (focusNode != null ) {
            focusNode.nextFocus();
          }
        },
        inputFormatters: inputFormatters,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: decoration ?? InputDecoration(
          hintText: hintText,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  static Widget titleText({required String title}) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 6.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
        ),
      ),
    );
  }

  static Widget childText({required String text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  static void showErrorDialog({required String message}) {
    Get.dialog(
      AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  static void showSnackBar({required String title}) {
    Get.showSnackbar(
      GetSnackBar(
        message: title,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
