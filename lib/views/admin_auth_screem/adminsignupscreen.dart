import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/adminAuth_controller.dart';
import 'package:flutter_application_2/views/admin_auth_screem/adminloginscreen.dart';
import 'package:flutter_application_2/widgets_common/custom_textfield.dart';


class AdminsignupScreen extends StatefulWidget {
  final String userId;
   const AdminsignupScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AdminsignupScreen> createState() => _AdminsignupScreenState();
}

class _AdminsignupScreenState extends State<AdminsignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AdminAuthController());

  
  //text controller
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

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
              normalText(text: welcome, size: 18.0),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellow),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(icAdminlogo, width: 70, height: 70),
                  ),
                  const SizedBox(width: 10),
                  boldText(text: appname, size: 18),
                ],
              ),
              const SizedBox(height: 30),
              Obx(() =>Column(
                children:[
                 customTextField(hint: nameHint,title: name, controller: nameController,isPass: false),               
                 customTextField(hint: emailHint,title: email,controller: emailController,isPass: false),
                 customTextField(hint: passwordHint,title: password,controller: passwordController,isPass: true),
                 customTextField(hint: passwordHint,title: retypePassword,controller: passwordRetypeController,isPass: true),
                //  Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(onPressed: (){}, child: forgetPass.text.make())),
                  5.heightBox,
                  
                  
                 Row(children: [
                  Checkbox(
                    checkColor: Colors.yellow,
                    value: isCheck,
                     onChanged: (newValue){
                      setState(() {
                         isCheck = newValue;
                      });
                     
                     },
                     ),
                     10.widthBox,
                     Expanded(
                       child: RichText(text:const TextSpan(
                        children: [
                          TextSpan(text:"I agree to the", style: TextStyle(
                            fontFamily: regular,
                            color: fontGrey,
                          )),
                          
                          TextSpan(text:termAndCond, style: TextStyle(
                            fontFamily: regular,
                            color: Colors.orange,
                          )),
                          
                          TextSpan(text:"&", style: TextStyle(
                            fontFamily: regular,
                            color: fontGrey,
                          )),
                     
                           TextSpan(
                            text:privacyPolicy, 
                            style: TextStyle(
                            fontFamily: regular,
                            color: Colors.orange,
                          ))
                        ],
                       )),
                     ),
                     ],
                 ),
                 controller.isloading.value?const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.yellow),
                   ): ourButton(color: isCheck == true? Colors.orange : lightGrey, 
                   title: signup, 
                   textColor: whiteColor,
                   onPress: () async {
                 if(isCheck !=false){
                  controller.isloading(true);
                  try {
                    await controller.signupMethod(context: context,email: emailController.text,password: passwordController.text).then((value){
                      return controller.storeUserData(
                        email: emailController.text,
                        password: passwordController.text,
                        name: nameController.text);
                    }).then((value){
                      VxToast.show(context, msg: signedin
                      ); 
                      Get.offAll(()=> AdminLoginScreen (userId: controller.getUserId(),));
                    });
                  } catch (e) {
                    auth.signOut();
                    VxToast.show(context, msg: e.toString());
                    controller.isloading(false);
                  }
                 }
                 },
                 ).box
                  .width(context.screenWidth-50)
                  .make(),
                  10.heightBox,
                  //wrapping into gesture detector of velocity_x
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,      
                  children: [
                    alreadyHaveAccount.text.color(fontGrey).make(),
                    login.text.color(Colors.orange).make().onTap(() {
                      Get.back();
                    }),
                  ],
                 ),
               
                ],
              ).box.white.rounded.padding(const EdgeInsets.all(16)).width(context.screenWidth -70).shadowSm.make(),
            )
          ],
        ),
      ),
    )));
  }
}