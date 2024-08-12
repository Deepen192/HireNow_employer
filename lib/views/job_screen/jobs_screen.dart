import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/jobs_controller.dart';
import 'package:flutter_application_2/services/store_services.dart';
import 'package:flutter_application_2/views/job_screen/add_job.dart';
import 'package:flutter_application_2/views/job_screen/job_details.dart';
import 'package:flutter_application_2/views/job_screen/jobedit.dart';
import 'package:flutter_application_2/widgets_common/loading_indicator.dart';

class JobsScreen extends StatelessWidget {
  final String userId;
  const JobsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    var controller =Get.put(JobsController(userId:userId));
    return Scaffold(
      backgroundColor: whiteColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: fontGrey,
        onPressed: ()async{
          await controller.getCategories();
          controller.populateCategoryList();
          Get.to(() =>const Addjobs());
        },child: const Icon(Icons.add),),
        appBar:appbarWidget(jobs),
        body:StreamBuilder(
          stream: StoreServices.getProducts(userId),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
            if(!snapshot.hasData){
              return loadingIndicator();
            }else {
              var data = snapshot.data!.docs;
              return Padding(padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children:
           List.generate(data.length, (index) => Card(
            child: ListTile(
                    onTap: (){
                      Get.to(()=>   JobsDetails(data: data[index], userId: userId,));
                    },
                    // leading: Image.network(data[index]['p_imgs'][0],width: 100, height: 100, fit: BoxFit.cover),
                    title: boldText(text: "${data[index]['p_name']}",color: fontGrey),
                    subtitle: Row(
                      children: [
                        normalText(text: "Rs.${data[index]['p_price']}",color: darkFontGrey),
                        10.widthBox,
                        boldText(text: data[index]['is_featured']==true?"Featured":'',color: green),
                      ],
                    ),
                    trailing: VxPopupMenu(
                      arrowSize: 0.0,
                      menuBuilder: ()=>Column(
                        children: List.generate(
                          popupMenuTitles.length, 
                        (i) => Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [Icon(popupMenuIcons[i],
                           
                            color:data[index]['featured_id']==userId && i ==0
                            ? green
                            : darkFontGrey,
                            ),
                            10.widthBox,
                            normalText(text:data[index]['featured_id']==userId && i ==0
                            ? 'Remove feature' 
                            :popupMenuTitles[i],color: darkFontGrey)
                            ],
                          ).onTap(() {
                           switch (i) {
                             case 0:
                              if(data[index]['is_featured']==true){
                              controller.removeFeatured(data[index].id);
                              VxToast.show(context, msg: "Removed");
                           }else{
                            controller.addFeatured(data[index].id);
                            VxToast.show(context, msg: "Added");
                           }
                               
                               break;
                               case 1:
                              Get.to(EditJobScreen(productId: data[index].id, userId:userId,));

                               break;
                               case 2:
                               controller.removeProduct(data[index].id);
                               VxToast.show(context, msg: "Product removed");
                               break;
                             default:
                           }
                           }),
                        ),
                        ),
                        ).box.white.width(200).make(),
                    clickType: VxClickType.singleClick,
                     child: const Icon(Icons.more_vert_rounded)),                 
                  ),
                  ),
        ),
      ),
      ),
      
    );
            }
          },
        ),
   
    );
  }
}