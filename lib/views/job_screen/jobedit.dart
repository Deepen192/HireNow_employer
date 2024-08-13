import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/jobedit_controller.dart';
import 'package:flutter_application_2/widgets_common/loading_indicator.dart';
import '../../widgets_common/admincustom_textfield.dart';

class EditJobScreen extends StatelessWidget {
  final String productId;
  final String userId;
  const EditJobScreen({super.key, required this.productId, required this.userId});

  

  @override
  Widget build(BuildContext context) {    

    var controller = Get.put(EditJobsController(userId:userId));

    // Fetch and load the existing product data when the screen is initialized
    Future<void>    jobProductData() async {
      await controller.loadJobData(productId);
    }

    // Call the function to load the product data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jobProductData();
    });

    // Call the function to load the product data
    jobProductData();

    //Add Color here
   return Obx(
      () => Scaffold(
        backgroundColor: fontGrey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: boldText(text: "Update Product", color: Colors.white, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: whiteColor)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);                                           
                     
                     
                      
                       await controller.updateJob(context, productId);
                                          Get.back();
                    },
                    style: TextButton.styleFrom(                      
                    ),
                    child: boldText(text: "Save", color: whiteColor)),
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
               customTextField(hint: "eg.Rupandehi, Tilottama-15, Supauli",label: "Address",isDesc:true,controller: controller.paddressController),  
               customTextField(hint: "eg.Halftime/Fulltime",label: "Job Type",isDesc:true,controller: controller.pjobtypeController),
                customTextField(hint: "eg.Male/Female",label: "Gender",isDesc:true,controller: controller.pgenderController),
                TextFormField(
                  controller: controller.pkeywordsController,
                  style: const TextStyle(color: whiteColor),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: "Keywords (comma-separated)",
                    labelStyle: const TextStyle(color: whiteColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: whiteColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: whiteColor),
                    ),
                    hintText: "eg. Flutter, Dart, Firebase",
                    hintStyle: const TextStyle(color: lightGrey),
                  ),
                ),                              
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
            
            ],
          ), 
          ),
        ),
      ),
    );
  }
}