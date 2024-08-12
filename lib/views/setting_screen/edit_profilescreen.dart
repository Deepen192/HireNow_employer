import 'dart:io';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/settingprof_controller.dart';
import 'package:flutter_application_2/widgets_common/admincustom_textfield.dart';
import 'package:flutter_application_2/widgets_common/loading_indicator.dart';

class EditSettingScreen extends StatefulWidget {
  final String userId;
  final String? username;
  const EditSettingScreen({super.key, this.username, required this.userId});
  @override
  State<EditSettingScreen> createState() => _EditSettingScreenState();
}

class _EditSettingScreenState extends State<EditSettingScreen> {
  var controller = Get.find<SettingProfController>();

  @override
  void initState() {
    controller.nameController.text = widget.username!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: fontGrey,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white), 
          title: boldText(text: officeSettings, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator()
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);

                      // if image is selected, upload it
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink = controller.snapshotData['imageUrl'];
                      }

                      // Check if old password matches database
                      if (controller.snapshotData['password'] == controller.oldpasswordController.text) {
                        // Check if new password is not empty and different from old password
                        if (controller.newpasswordController.text.isNotEmpty &&
                            controller.newpasswordController.text != controller.oldpasswordController.text) {
                          await controller.changeAuthPassword(
                            email: controller.snapshotData['email'],
                            password: controller.oldpasswordController.text,
                            newpassword: controller.newpasswordController.text,
                          );

                          await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.newpasswordController.text,
                          );

                          VxToast.show(context, msg: "Updated");
                        } else {
                          VxToast.show(context, msg: "New password must be different from the old one");
                        }
                      } else if (controller.oldpasswordController.text.isEmptyOrNull &&
                          controller.newpasswordController.text.isEmptyOrNull) {
                        // Update profile without changing password
                        await controller.updateProfile(
                          imgUrl: controller.profileImageLink,
                          name: controller.nameController.text,
                          password: controller.snapshotData['password'],
                        );
                        VxToast.show(context, msg: "Updated");
                      } else {
                        VxToast.show(context, msg: "Incorrect old password");
                      }

                      controller.isloading(false);
                    },
                    child: normalText(text: save),
                  ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Display profile image
                controller.snapshotData['imageUrl'] == '' && controller.profileImgPath.isEmpty
                    ? Image.asset(imgProduct, width: 100, fit: BoxFit.cover)
                        .box.roundedFull.clip(Clip.antiAlias).make()
                    : controller.snapshotData['imageUrl'] != '' && controller.profileImgPath.isEmpty
                        ? Image.network(controller.snapshotData['imageUrl'], width: 100, fit: BoxFit.cover)
                            .box.roundedFull.clip(Clip.antiAlias).make()
                        : Image.file(
                            File(controller.profileImgPath.value),
                            width: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),
                10.heightBox,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
                  onPressed: () {
                    controller.changeImage(context);
                  },
                  child: normalText(text: changeImage, color: fontGrey),
                ),
                10.heightBox,
                const Divider(color: whiteColor),
                customTextField(label: userName, hint: "eg.Deepen B.k", controller: controller.nameController),
                30.heightBox,
                Align(alignment: Alignment.centerLeft, child: boldText(text: "Change your Password")),
                10.heightBox,
                customTextField(label: password, hint: passwordHint, controller: controller.oldpasswordController,  isPassword: true,),
                10.heightBox,
                customTextField(label: confirmPass, hint: passwordHint, controller: controller.newpasswordController,  isPassword: true,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
