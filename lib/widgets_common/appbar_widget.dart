import 'package:flutter_application_2/consts/consts.dart';
import 'package:intl/intl.dart' as intl;
AppBar appbarWidget(title){
  return AppBar(
        backgroundColor: fontGrey,
        automaticallyImplyLeading: false,
        title: boldText(text: title,color: whiteColor,size: 16.0),
        actions: [
          Center(
            child: normalText(text:intl.DateFormat( 'EEE, MMM d, ' 'yy'   ).format(DateTime.now()),color: purpleColor)),
            10.heightBox,            
        ],
      );
}