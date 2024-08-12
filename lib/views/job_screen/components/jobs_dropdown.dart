import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/jobs_controller.dart';
Widget jobsDropdown(hint,List<String>list,dropvalue,JobsController controller){
  return Obx(
    ()=>DropdownButtonHideUnderline(
      child:DropdownButton(
        hint: normalText(text: "$hint",color: fontGrey),
        value: dropvalue.value==''? null:dropvalue.value,
        isExpanded: true,
        items:  list.map((e){
          return DropdownMenuItem(
             value: e,
            child: e.toString().text.make(),
         );
        }).toList(),
        onChanged: (newValue){
          if(hint=="Category"){
            controller.subcategoryvalue.value='';
            controller.populateSubcategory(newValue.toString());
          }
          dropvalue.value=newValue.toString();
        },
      ),
       ).box.white.padding(const EdgeInsets.symmetric(horizontal: 4)).roundedSM.make(),
  );
}