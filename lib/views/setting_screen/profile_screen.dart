import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/controllers/adminAuth_controller.dart';
import 'package:flutter_application_2/controllers/settingprof_controller.dart';
import 'package:flutter_application_2/services/store_services.dart';
import 'package:flutter_application_2/views/admin_auth_screem/adminloginscreen.dart';
import 'package:flutter_application_2/views/setting_screen/edit_profilescreen.dart';
import 'package:flutter_application_2/views/setting_screen/vacancy_completed_report.dart';
import 'package:flutter_application_2/views/shop_screen/highdemand.dart';
import 'package:flutter_application_2/views/shop_screen/office_details.dart';
import 'package:flutter_application_2/views/shop_screen/office_setting_screen.dart';
import 'package:flutter_application_2/views/message_screen/adminmessage_screen.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/views/user_manage/staff_screen.dart';
import 'package:flutter_application_2/widgets_common/loading_indicator.dart';

class SettingScreen extends StatelessWidget {
  final String userId;
  const SettingScreen({super.key, required this.userId});
  
  @override
  Widget build(BuildContext context) {
    var controller =Get.put(SettingProfController(userId:userId));
    return Scaffold(
      backgroundColor: fontGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: settings, size: 16.0),
        actions:[
          IconButton(
            onPressed:(){
              Get.to(()=>  EditSettingScreen(
                username: controller.snapshotData['vendor_name'], userId:userId,
              ));
              },icon:  const Icon(Icons.edit), color: Colors.white),
          TextButton(onPressed: () async {
            await Get.find<AdminAuthController>().signoutMethod(context);
            Get.offAll(()=> const AdminLoginScreen(userId: '',));
          }, 
          child: normalText(text:logout),
          )
        ],
      ),
      body: StreamBuilder(
        stream: StoreServices.getProfile(userId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
            if(!snapshot.hasData){
              return loadingIndicator(circleColor: whiteColor);
            }else{
            controller.snapshotData = snapshot.data!.docs[0];
              return Column(
        children: [
          ListTile(
            leading:  controller.snapshotData['imageUrl']==''
                  ?  Image.asset(imgProduct, width: 100,fit:BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make()
                  :
                    Image.network(controller.snapshotData['imageUrl'], width: 100,fit:BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make(),
            //leading: Image.asset(imgProduct).box.roundedFull.clip(Clip.antiAlias).make(),
            title: boldText(text: "${controller.snapshotData['vendor_name']}"),
            subtitle: normalText(text: "${controller.snapshotData['email']}"),
          ),
          const Divider(),
      10.heightBox,      
      Padding(
        padding:  const EdgeInsets.all(8.0),
        child: Column(
          children: List.generate(
            settingButtonsIcons.length, 
            (index) => ListTile(
              onTap: (){
                switch (index) {
                  case 0:
                    Get.to(()=>  OfficeSetting(userId:userId,));
                    break;
                    case 1:
                    Get.to(()=>  AdminMessagesScreen(userId: userId,));
                    break;                                      
                     case 2:  Get.to(()=>   AdminUserManagementScreen(userId:userId,));
                     break;
                     case 3:  Get.to(()=>   HighDemandAdminScreen(userId:userId,));
                     break; 
                     case 4:  Get.to(()=>   VacncySoldScreen(userId:userId,));
                     break;         
                  default:
                  Get.to(()=>  OfficeDetailsScreen(userId:userId,));
                  break;
                }
              },
            leading: Icon(settingButtonsIcons[index],color:whiteColor),
            title: normalText(text: settingButtonsTitles[index]),
          )),
        ),
        ),
        ],
      );
        }            
      },
      ),
    );
  }
}