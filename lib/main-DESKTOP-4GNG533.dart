import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/views/admin_auth_screem/adminloginscreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{  
  const MyApp({Key? key}) : super(key: key);  
  
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    //we are using getx so need to change material in get materialapp
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      
      title: 'The Choice',
      theme: ThemeData( 
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          //to set app bar icons color
          iconTheme: IconThemeData(
            color: darkFontGrey,
          ),
          
          elevation: 0.0,
          backgroundColor:Colors.transparent),
        fontFamily: regular,
        
      ),
      home: const AdminLoginScreen(userId:'',),
    );
  }
}