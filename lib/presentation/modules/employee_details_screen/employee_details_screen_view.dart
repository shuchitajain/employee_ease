import 'package:employee_ease/presentation/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import 'employee_details_screen_logic.dart';

class EmployeeDetailsScreenView extends GetView<EmployeeDetailsScreenLogic> {
  const EmployeeDetailsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = Get.mediaQuery.viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Text(
          'Employee Details',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.sp,
              color: AppColors.black,
          ),
        ),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        margin: EdgeInsets.only(bottom: keyboardHeight),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: controller.employee.id!,
                        child: Container(
                          height: 200.h,
                          width: 200.w,
                          margin: EdgeInsets.only(top: 20.h, bottom: 40.h),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                controller.employee.name[0].toUpperCase(),
                                style: GoogleFonts.dancingScript(
                                  color: AppColors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 70.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppWidgets.userInputField(
                    hintText: 'Name',
                    controller: controller.textControllers['Name'],
                    focusNode: controller.focusNodes['Name']!.value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    decoration: controller.inputDecoration(
                      'Name',
                      FontAwesomeIcons.solidUser,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
                    child: const Text(
                      'Address',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight
                          .bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppWidgets.userInputField(
                          hintText: 'Line 1',
                          controller: controller.textControllers['Line 1'],
                          focusNode: controller.focusNodes['Line 1']!.value,
                          decoration: controller.inputDecoration(
                            'Line 1',
                            FontAwesomeIcons.mapLocation,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: AppWidgets.userInputField(
                          hintText: 'City',
                          controller: controller.textControllers['City'],
                          focusNode: controller.focusNodes['City']!.value,
                          decoration: controller.inputDecoration(
                            'City',
                            FontAwesomeIcons.city,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppWidgets.userInputField(
                          hintText: 'Country',
                          controller: controller.textControllers['Country'],
                          focusNode: controller.focusNodes['Country']!.value,
                          decoration: controller.inputDecoration(
                            'Country',
                            FontAwesomeIcons.globe,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: AppWidgets.userInputField(
                          hintText: 'Zip code',
                          keyboardType: TextInputType.number,
                          controller: controller.textControllers['Zip code'],
                          focusNode: controller.focusNodes['Zip code']!.value,
                          decoration: controller.inputDecoration(
                            'Zip code',
                            FontAwesomeIcons.locationDot,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
                    child: const Text(
                      'Contact Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight
                          .bold),
                    ),
                  ),
                  AppWidgets.userInputField(
                    hintText: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.textControllers['Email address'],
                    focusNode: controller.focusNodes['Email address']!.value,
                    decoration: controller.inputDecoration(
                      'Email address',
                      FontAwesomeIcons.envelope,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppWidgets.userInputField(
                    hintText: 'Phone number',
                    keyboardType: TextInputType.phone,
                    controller: controller.textControllers['Phone number'],
                    focusNode: controller.focusNodes['Phone number']!.value,
                    decoration: controller.inputDecoration(
                      'Phone number',
                      FontAwesomeIcons.phone,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: AppColors.white,
                        minimumSize: const Size(200, 50),
                      ),
                      onPressed: () => controller.saveEmployeeDetails(),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
