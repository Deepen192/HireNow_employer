
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/adminAuth_controller.dart';
import 'package:flutter_application_2/views/admin_auth_screem/adminsignupscreen.dart';
import 'package:flutter_application_2/views/admin_auth_screem/passwordreset.dart';
import 'package:flutter_application_2/widgets_common/custom_textfield.dart';


import '../home_screen/admin_home.dart';

class AdminLoginScreen extends StatelessWidget {
  final String userId;
  const AdminLoginScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    var controller =Get.put(AdminAuthController());
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                boldText(text: welcome, size: 18.0),
                boldText(text: appname, size: 18),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(icAdminlogo, width: 70, height: 70),
                ),
                const SizedBox(width: 10),
                const SizedBox(height: 30),
             Obx(
               () =>Center(
                 child: Column(
                  children:[
                   customTextField(hint: emailHint,title: email,isPass: false,controller: controller.emailController),
                   customTextField(hint: passwordHint,title: password,isPass: true,controller: controller.passwordController),
                   Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => ForgotPasswordScreen());
                    }, child: forgetPass.text.make())),
                    5.heightBox,
                     controller.isloading.value
                     ?const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.yellow),
                     )
                     : ourButton(color: Colors.grey,title: login, textColor: whiteColor,onPress: () async{
                     controller.isloading(true);
                       await controller.loginMethod(
                        email: controller.emailController.text,
                        password: controller.passwordController.text,
                        context: context,
                      ).then((value) {
                        if (value != null) {
                          VxToast.show(context, msg: loggedin);
                          Get.offAll(() =>  AdminHome(userId: userId,));
                        } else {
                          controller.isloading(false);
                        }
                      });
                    },
                  )
                    .box
                    .width(context.screenWidth-50)
                    .make(),
                    5.heightBox,
                    createNewAccount.text.color(Colors.grey).make(),
                    5.heightBox,
                    ourButton(color: lightGolden,title: signup, textColor: whiteColor,onPress: (){
                      Get.to(() => AdminsignupScreen(userId: userId,));
                    })
                    .box
                    .width(context.screenWidth-50)
                    .make(),
                             
                    10.heightBox,
                    // loginWith.text.color(fontGrey).make(),
                    // 5.heightBox,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children:List.generate(
                    //     3,
                    //      (index) => Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //        child: CircleAvatar(
                    //         backgroundColor: lightGrey,
                    //         radius: 25,
                    //         child: Image.asset(
                    //         socialIconList[index],
                    //          width: 30,
                    //          ),
                    //          ),
                    //      )),
                    // ),
                  ],
                               ).box.white.rounded.padding(const EdgeInsets.all(16)).width(context.screenWidth -70).shadowSm.make(),
               ),
            )
          ],
        ),
      ),
    )));
  }
}
       