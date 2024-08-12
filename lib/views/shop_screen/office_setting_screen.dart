import 'package:flutter/material.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/settingprof_controller.dart';
import 'package:flutter_application_2/widgets_common/admincustom_textfield.dart';
import 'package:flutter_application_2/widgets_common/loading_indicator.dart';

class OfficeSetting extends StatefulWidget {
  final String userId;
  const OfficeSetting({Key? key, required this.userId}) : super(key: key);

  @override
  State<OfficeSetting> createState() => _OfficeSettingState();
}

class _OfficeSettingState extends State<OfficeSetting> {
  late SettingProfController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.find<SettingProfController>();
    controller.loadOfficeData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    // var controller = Get.find<SettingProfController>();
    // controller.loadOfficeData(widget.userId);
    return Obx(
      () => Scaffold(
        backgroundColor: fontGrey,
        appBar: AppBar(
          
          backgroundColor: fontGrey,
          iconTheme: const IconThemeData(color: Colors.white), 
          title: boldText(text: officeSettings, size: 16.0),
           leading: IconButton(onPressed: (){
            Get.back();
            // controller.resetForm();
          }, icon: const Icon(Icons.arrow_back,color: whiteColor,)),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: fontGrey)
                : TextButton(
                    onPressed: () async {
                      if (validateFields(controller)) {
                        controller.isloading(true);
                        controller.updateOffice(
                          officeaddress: controller.officeAddressController.text,
                          officename: controller.officeNameController.text,
                          officemobile: controller.officeMobileController.text,
                          officewebsite: controller.officeWebsiteController.text,
                          officedesc: controller.officenDescController.text,
                          officeemailaddress: controller.officeEmailAddressController.text,
                        );
                        // controller.resetForm();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Office Setting Updated"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Fill all fields"),
                              content: Text("Please fill all the fields before updating the office."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: normalText(text: save),
                  )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: customTextField(
                    label: officeDetails,
                    hint: nameHint,
                    controller: controller.officeNameController,
                  ),
                ),
                SizedBox(height: 10),
                customTextField(
                  label: address,
                  hint: officeAddressHint,
                  controller: controller.officeAddressController,
                ),
                SizedBox(height: 10),
                customTextField(
                  label: mail,
                  hint: officeEmailAddress,
                  controller: controller.officeEmailAddressController,
                ),
                SizedBox(height: 10),
                customTextField(
                  label: mobile,
                  hint: officeMobileHint,
                  controller: controller.officeMobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
                SizedBox(height: 10),
                customTextField(
                  label: website,
                  hint: officeWebsiteHint,
                  controller: controller.officeWebsiteController,
                ),
                SizedBox(height: 10),
                customTextField(
                  isDesc: true,
                  label: description,
                  hint: officeDescHint,
                  controller: controller.officenDescController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateFields(SettingProfController controller) {
    return controller.officeNameController.text.isNotEmpty &&
        controller.officeAddressController.text.isNotEmpty &&
        controller.officeMobileController.text.isNotEmpty &&
        controller.officeWebsiteController.text.isNotEmpty &&
        controller.officenDescController.text.isNotEmpty;
  }
}
