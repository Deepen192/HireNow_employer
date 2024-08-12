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
               customTextField(hint: "eg.Rupandehi",label: "District",isDesc:true,controller: controller.pdicstrictController),  
               customTextField(hint: "eg.Supauli",label: "Street",isDesc:true,controller: controller.pstreetController),               
              10.heightBox,
               TextFormField(
                  controller: controller.pwardController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: whiteColor),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: "Ward No.",
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
                 // Input field and buttons for discount calculation
          //    TextFormField(
          //   controller: controller.discountController,
          //   keyboardType: const TextInputType.numberWithOptions(decimal: true),
          //   decoration: InputDecoration(
          //     isDense: true,
          //     label: normalText(text: "Discount(%)"),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(12),
          //       borderSide: const BorderSide(
          //         color: Colors.white,
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(12),
          //       borderSide: const BorderSide(
          //         color: Colors.white,
          //       ),
          //     ),
          //     hintText: "eg. 10",
          //     hintStyle: const TextStyle(color: Colors.grey),
          //   ),
          // ),
          5.heightBox,
            //   ElevatedButton(
            //     onPressed: () {
            //       double discountPercentage = double.tryParse(controller.discountController.text) ?? 0.0;
            //       double originalPrice = double.tryParse(controller.ppriceController.text) ?? 0.0;

            //       controller.calculateDiscountedPrice(originalPrice, discountPercentage);
            //     },
            //     style: ElevatedButton.styleFrom(
            //  backgroundColor: whiteColor, // Text color
            //   elevation: 0, // Set elevation to 0 to remove shadow
            // ),
            //     child: const Text("Calculate Tax"),
            //   ),
              // 5.heightBox,
              // if (controller.discountedPrice.value > 0)
              //   Text('Price after Tax:  Rs.${controller.discountedPrice.value.toStringAsFixed(2)}'),
              // 15.heightBox,
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
              // 10.heightBox,
              // const Divider(color: whiteColor),
              // boldText(text: "Choose Jobs images"),
              // 10.heightBox,
              // Obx(
              //   ()=> Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: List.generate(
              //       3,
              //      (index) => controller.pImagesList[index]!=null
              //      ?Image.file(controller.pImagesList[index]!,
              //      width: 100,
              //      ).onTap(() {
              //       controller.pickImage(index, context);
              //      })
              //      :productImages(label: "${index +1}").onTap(() {
              //       controller.pickImage(index, context); 
              //     }),
              //     ),
              //   ),
              // ),
              // 5.heightBox,
              // normalText(text: "First image will be your display image",color: lightGrey),
              //  const Divider(color: whiteColor),
              10.heightBox,
              // boldText(text: "Choose product colors"),
              // 10.heightBox,
//             Wrap(
//   spacing: 8.0,
//   runSpacing: 8.0,
//   children: controller.colorOptions.map((colorValue) {
//     final color = Color(colorValue.toInt());
//     return GestureDetector(
//       onTap: () {
//         controller.toggleColorSelection(colorValue.toString());
//       },
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           VxBox()
//               .color(color)
//               .roundedFull
//               .size(65, 65)
//               .make(),
//           controller.isColorSelected(colorValue.toString())
//               ? const Icon(Icons.done, color: Colors.white)
//               : const SizedBox(),
//         ],
//       ),
//     );
//   }).toList(),
// )

            ],
          ), 
          ),
        ),
      ),
    );
  }
}