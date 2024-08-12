import 'dart:io';

import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/jobedit_controller.dart';
import 'package:flutter_application_2/views/job_screen/components/job_images.dart';
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
              customTextField(hint: "eg.Flutter Developer",label: "Job name",controller: controller.pnameController),
              10.heightBox,
               customTextField(hint: "eg.High Demand",label: "Description",isDesc:true,controller: controller.pdescController),           
              10.heightBox,
              customTextField(hint: "eg. Rs.100",label: "Price",controller: controller.ppriceController),
              10.heightBox,
               TextFormField(
            controller: controller.discountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              isDense: true,
              label: normalText(text: "Discount(%)"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              hintText: "eg. 10",
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
          5.heightBox,
              ElevatedButton(
                onPressed: () {
                  double discountPercentage = double.tryParse(controller.discountController.text) ?? 0.0;
                  double originalPrice = double.tryParse(controller.ppriceController.text) ?? 0.0;

                  controller.calculateDiscountedPrice(originalPrice, discountPercentage);
                },
                style: ElevatedButton.styleFrom(
               backgroundColor: whiteColor,
                elevation: 0, // Set elevation to 0 to remove shadow
              ),
                child: const Text("Calculate Discount",style: TextStyle(color: Colors.black),),
              ),
              5.heightBox,
              if (controller.discountedPrice.value > 0)
                Text('Discounted Price: Rs.${controller.discountedPrice.value.toStringAsFixed(2)}'),
              15.heightBox,
             
              customTextField(hint: "eg. 20",label: "Vacany",controller: controller.pquanitytController),
              10.heightBox,
              //  const Divider(color: whiteColor),
              boldText(text: "Choose product images"),
              10.heightBox,
              Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      3,
                      (index) {
                        var image = controller.pImagesList[index];
                        return image != null
                          ? (image is File
                            ? Image.file(
                                image,
                                width: 100,
                              ).onTap(() {
                                controller.pickImage(index, context);
                              })
                            : Image.network(
                                image as String,
                                width: 100,
                              ).onTap(() {
                                controller.pickImage(index, context);
                              }))
                          : productImages(label: "${index + 1}").onTap(() {
                              controller.pickImage(index, context);
                            });
                      },
                    ),
                  ),
                ),
              5.heightBox,
              normalText(text: "First image will be your display image",color: lightGrey),
               const Divider(color: whiteColor),
               const Divider(color: whiteColor),
              10.heightBox,
               
            ],
          ), 
          ),
        ),
      ),
    );
  }
}