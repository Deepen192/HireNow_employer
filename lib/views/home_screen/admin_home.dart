import 'package:flutter_application_2/views/home_screen/admin_home_screen.dart';
import 'package:flutter_application_2/views/job_screen/components/vacancycomplete.dart';
import 'package:flutter_application_2/views/job_screen/jobs_screen.dart';
import 'package:flutter_application_2/views/userorders_screen/userorders_screen.dart';
import 'package:flutter_application_2/views/setting_screen/profile_screen.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/adminhome_controller.dart';


class AdminHome extends StatefulWidget {
  final String userId;
 const AdminHome({Key? key, required this.userId, }) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AdminHomeController());
    var navScreen=[
        AdminHomeScreen(userId: controller.userId,),  JobsScreen(userId: controller.userId),   ApplicantScreen(userId: controller.userId), VacancyCompletedScreen(userId: controller.userId), SettingScreen(userId: controller.userId),
    ];
     var bottomNavBar =[
    const  BottomNavigationBarItem(icon:Icon(Icons.home),label: dashboard),
       BottomNavigationBarItem(icon: Image.asset(icAdminproduct,color:darkFontGrey, width: 24), label: jobs),
        BottomNavigationBarItem(icon: Image.asset(icAdminorder,color:darkFontGrey, width: 24),label: applicants),
             BottomNavigationBarItem(
        icon: Obx(() => Icon(Icons.warning, color: controller.hasLowStockProducts.value ? Colors.red : Colors.grey)),
        label: 'Notification',
      ),
           BottomNavigationBarItem(icon: Image.asset(icAdminGeneralset,color:darkFontGrey, width: 24),label: settings),
          ];
       
    return Scaffold(
      
    bottomNavigationBar: Obx(
      ()=>BottomNavigationBar(
        onTap: (index){
          controller.navIndex.value =index;
        },
        currentIndex: controller.navIndex.value,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: darkFontGrey, 
        items:bottomNavBar,
    
      ),
    ),
    body: Obx(
      ()=> Column(
        children: [
            Expanded(child: navScreen.elementAt(controller.navIndex.value),
            ),
        ],
      ),
    ),
      );
    
    
  }
}