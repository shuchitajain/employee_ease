import 'package:employee_ease/presentation/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import 'add_employee_screen_logic.dart';

class AddEmployeeScreenView extends GetView<AddEmployeeScreenLogic> {
  const AddEmployeeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = Get.mediaQuery.viewInsets.bottom;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.only(bottom: keyboardHeight),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add Employee',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  AppWidgets.userInputField(
                    hintText: 'Name',
                    controller: controller.textControllers['Name'],
                    focusNode: controller.focusNodes['Name'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
                    child: const Text(
                      'Address',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppWidgets.userInputField(
                          hintText: 'Line 1',
                          controller: controller.textControllers['Line 1'],
                          focusNode: controller.focusNodes['Line 1'],
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: AppWidgets.userInputField(
                          hintText: 'City',
                          controller: controller.textControllers['City'],
                          focusNode: controller.focusNodes['City'],
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
                          focusNode: controller.focusNodes['Country'],
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: AppWidgets.userInputField(
                          hintText: 'Zip code',
                          keyboardType: TextInputType.number,
                          controller: controller.textControllers['Zip code'],
                          focusNode: controller.focusNodes['Zip code'],
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  AppWidgets.userInputField(
                      hintText: 'Email address',
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.textControllers['Email address'],
                      focusNode: controller.focusNodes['Email address'],
                  ),
                  const SizedBox(height: 16),
                  AppWidgets.userInputField(
                    hintText: 'Phone number',
                    keyboardType: TextInputType.phone,
                    controller: controller.textControllers['Phone number'],
                    focusNode: controller.focusNodes['Phone number'],
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
                      onPressed: controller.submitForm,
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
