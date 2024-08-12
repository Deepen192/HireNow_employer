import 'package:flutter_application_2/consts/consts.dart';

Widget dashboardButton(context, {title,count,icon}) {
  var size = MediaQuery.of(context).size;
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            boldText(text: title, size: 16.0),
            boldText(text: count, size: 20.0),
          ],
        ),
      ),
      Image.asset(icon, width: 40, color: whiteColor),
    ],
  )
      .box
      .color(fontGrey)
      .rounded
      .size(size.width * 0.4, 80) // Use size.width from the MediaQuery
      .padding(const EdgeInsets.all(8))
      .make();
}
