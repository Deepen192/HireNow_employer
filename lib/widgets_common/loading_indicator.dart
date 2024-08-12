import 'package:flutter_application_2/consts/consts.dart';

Widget loadingIndicator({circleColor =purpleColor}){
  return  Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(circleColor),
    ),
  );
}