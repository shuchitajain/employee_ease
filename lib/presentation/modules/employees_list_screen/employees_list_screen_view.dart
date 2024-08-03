import 'package:employee_ease/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import 'employees_list_screen_logic.dart';

class EmployeesListScreenView extends GetView<EmployeesListScreenLogic> {
  const EmployeesListScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              expandedHeight: Get.height * 0.24,
              backgroundColor: AppColors.white,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.zero,
                centerTitle: false,
                expandedTitleScale: 1.0,
                title: Container(
                  height: 50.h,
                  margin:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: TextField(
                    onChanged: (value) => controller.filterEmployees(value),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 16.w, top: 12.h),
                        child: FaIcon(
                          FontAwesomeIcons.magnifyingGlass,
                          size: 20.h,
                          color: Colors.grey,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                background: const FloatingSearchBar(),
              ),
            ),
          ];
        },
        body: Obx(() => Column(
            children: [
              controller.filteredEmployees.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 16.h, bottom: 8.h),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    child: DropdownButton<String>(
                        value: controller.sortCriteria.value,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 30.h,
                        hint: Text(
                          'Sort by',
                          style: GoogleFonts.questrial(fontSize: 16.sp, color: AppColors.black),
                        ),
                        alignment: Alignment.center,
                        items: [
                          DropdownMenuItem(
                            value: 'Date Added',
                            child: Text(
                              'Date Added',
                              style: GoogleFonts.questrial(fontSize: 16.sp),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'A-Z',
                            child: Text(
                              'A-Z',
                              style: GoogleFonts.questrial(fontSize: 16.sp),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Z-A',
                            child: Text(
                              'Z-A',
                              style: GoogleFonts.questrial(fontSize: 16.sp),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          controller.setSortCriteria(value!);
                        },
                      ),
                  )
                  : const SizedBox(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeIn,
                  child: controller.filteredEmployees.isEmpty
                      ? Center(
                          key: const ValueKey('No Employees Found'),
                          child: Text(
                            'No Employees Found',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                      : RefreshIndicator(
                        key: controller.refreshIndicatorKey,
                        onRefresh: controller.refreshData,
                        child: ListView.separated(
                            key: const ValueKey('Employees List'),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.filteredEmployees.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 8.h),
                            itemBuilder: (context, index) {
                              final employee =
                                  controller.filteredEmployees[index];
                              //debugPrint('Date Added: ${employee.dateAdded}');
                              final AnimationController? animationController = controller.animationControllers[employee.id];
                              if(animationController == null) {
                                debugPrint('Animation Controller is null');
                                return const SizedBox.shrink();
                              }
                              return AnimatedBuilder(
                                animation: animationController,
                                builder: (context, child) {
                                  return SizeTransition(
                                    sizeFactor: animationController,
                                    axis: Axis.horizontal,
                                    child: FadeTransition(
                                      opacity: animationController.drive(
                                        Tween<double>(begin: 1.0, end: 0.0),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            4.w, 10.h, 4.w, 10.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        height: 100.h,
                                        child: InkWell(
                                          onTap: () => Get.toNamed(
                                            AppRoutes.employeeDetailsScreen,
                                            arguments: employee,
                                          ),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 16.w, vertical: 14.h),
                                            tileColor: AppColors.white,
                                            leading: Hero(
                                              tag: employee.id!,
                                              child: Container(
                                                height: 50.h,
                                                width: 50.w,
                                                decoration: BoxDecoration(
                                                  color: AppColors.secondaryColor
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(10.r),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    employee.name[0].toUpperCase(),
                                                    style:
                                                        GoogleFonts.dancingScript(
                                                      color: AppColors.white,
                                                      fontSize: 20.sp,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 4.h),
                                              child: Text(
                                                employee.name,
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            subtitle: Text(
                                              employee.id.toString(),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            trailing: InkWell(
                                              child: const FaIcon(
                                                  FontAwesomeIcons.trashCan),
                                              onTap: () {
                                                debugPrint('Delete Employee');
                                                controller
                                                    .deleteEmployee(employee.id!);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
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

class FloatingSearchBar extends StatelessWidget {
  const FloatingSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 50.h),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/appbar_bg.png'),
          colorFilter: ColorFilter.mode(
            Colors.black26,
            BlendMode.darken,
          ),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Employees',
            style: GoogleFonts.pacifico(
              color: AppColors.white,
              fontSize: 50.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.userPlus,
                color: AppColors.white,
              ),
              onPressed: () => Get.find<EmployeesListScreenLogic>()
                  .openAddEmployeeSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}
