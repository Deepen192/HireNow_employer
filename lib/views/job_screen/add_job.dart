import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/jobs_controller.dart';
import 'package:flutter_application_2/views/job_screen/components/jobs_dropdown.dart';
import 'package:flutter_application_2/widgets_common/loading_indicator.dart';

import '../../widgets_common/admincustom_textfield.dart';

class Addjobs extends StatelessWidget {
  
  const Addjobs({super.key});

  @override
  Widget build(BuildContext context) {    

    var controller =Get.find<JobsController>();
    //Add Color here
    return Obx(
      ()=> Scaffold(
        backgroundColor: fontGrey,
        appBar: AppBar(
            leading: IconButton(onPressed: (){
            Get.back();
            controller.resetForm();
          }, icon: const Icon(Icons.arrow_back,color: whiteColor,)),
          title: boldText(text: "Add jobs",color: whiteColor,size: 16.0),
           actions: [
            controller.isloading.value
            ? loadingIndicator(circleColor: whiteColor)
            : ElevatedButton(
  onPressed: () async {
    if (controller.pnameController.text.isEmpty ||
        controller.pdescController.text.isEmpty ||
        controller.ppriceController.text.isEmpty ||
        controller.pquanitytController.text.isEmpty ||
        controller.categoryvalue.isEmpty ||
        controller.subcategoryvalue.isEmpty) {
      // Inform the user to fill all the remaining fields
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Fill all fields"),
            content: Text("Please fill all the remaining fields before updating the jobs."),
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
    } else {
      // All required fields are filled, proceed with update
      controller.isloading(true);
      await controller.uploadJob(context);
      Get.back();
    }
  },
  child: const Text("Save"),
),

          ],
        ),
        body: Padding(
          padding:const EdgeInsets.all(8.0),
          child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
            physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTextField(hint: "eg.Flutter Developer",label: "Jobs name",controller: controller.pnameController),
              10.heightBox,
               customTextField(hint: "eg.You can use firebase",label: "Job Description",isDesc:true,controller: controller.pdescController),
               customTextField(hint: "eg.Bachelor holder",label: "Requirement",isDesc:true,controller: controller.preqController),
               customTextField(hint: "eg.Backend and Frontend",label: "Roles & Responsibilty",isDesc:true,controller: controller.prolresController),
               customTextField(hint: "eg.District, Minicipality/Village, Street",label: "Full Address",isDesc:true,controller: controller.paddressController),  
               customTextField(hint: "eg.Half time/Full time",label: "Job Type,",isDesc:true,controller: controller.pjobtypeController),
               customTextField(hint: "eg.11am-5pm",label: "Job Time,",isDesc:true,controller: controller.pjobtimeController),
               customTextField(hint: "eg.Male/Female",label: "Gender",isDesc:true,controller: controller.pgenderController),
                                             
              10.heightBox,
              //  TextFormField(
              //     controller: controller.pwardController,
              //     keyboardType: TextInputType.number,
              //     style: const TextStyle(color: whiteColor),
              //     decoration: InputDecoration(
              //       isDense: true,
              //       labelText: "Ward No.",
              //       labelStyle: const TextStyle(color: whiteColor),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: const BorderSide(color: whiteColor),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: const BorderSide(color: whiteColor),
              //       ),
              //       hintText: "eg. Rs.100",
              //       hintStyle: const TextStyle(color: lightGrey),
              //     ),
              //   ),
                10.heightBox,
              TextFormField(
                  controller: controller.ppriceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: whiteColor),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: "Price",
                    labelStyle: const TextStyle(color: whiteColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: whiteColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: whiteColor),
                    ),
                    hintText: "eg. Rs.100",
                    hintStyle: const TextStyle(color: lightGrey),
                  ),
                ),
              10.heightBox,    
              TextFormField(
  controller: controller.pquanitytController,
  keyboardType: TextInputType.number, // Show only number keypad
  style: const TextStyle(color: whiteColor),
  decoration: InputDecoration(
    isDense: true,
    labelText: "Vacancy",
    labelStyle: const TextStyle(color: whiteColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: whiteColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: whiteColor),
    ),
    hintText: "eg. 20",
    hintStyle: const TextStyle(color: lightGrey),
  ),
),
              10.heightBox,
              jobsDropdown("Category", controller.categoryList,controller.categoryvalue,controller),
               10.heightBox,
              jobsDropdown("Subcategory",controller.subcategoryList,controller.subcategoryvalue,controller),

            ],
          ), 
          ),
        ),
      ),
    );
  }
}