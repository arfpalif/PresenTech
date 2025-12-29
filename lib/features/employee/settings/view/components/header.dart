import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/settings/controller/employee_setting_controller.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class Header extends GetView<EmployeeSettingController> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        width: 48,
        height: 48,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(200),
          child: Obx(() {
            return Image.network(
              controller.profilePictureUrl.value.isNotEmpty
                  ? controller.profilePictureUrl.value
                  : 'https://www.gravatar.com/avatar/?d=mp',
              fit: BoxFit.cover,
            );
          }),
        ),
      ),
      title: Obx(
        () => Text(controller.name.value, style: AppTextStyle.heading1),
      ),
      subtitle: Obx(
        () => Text(
          controller.role.value,
          style: AppTextStyle.normal.copyWith(color: Colors.grey),
        ),
      ),
    );
  }
}
