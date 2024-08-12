import 'package:flutter/material.dart';
import 'package:flutter_application_2/consts/consts.dart';

Widget userOrderPlaceDetails({
  required String title1,
  required String title2,
  required String d1,
  dynamic d2, // Make d2 dynamic to accept either String or Widget
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "$title1".text.fontFamily(semibold).make(),
              d1 == "Unpaid"
                  ? "$d1".text.color(Colors.orange).fontFamily(semibold).make()
                  : "$d1".text.color(Colors.green).fontFamily(semibold).make(),
            ],
          ),
        ),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "$title2".text.fontFamily(semibold).make(),
              if (d2 is String)
                "$d2".text.make()
              else if (d2 is Widget)
                d2 // Render the button widget directly
              else
                SizedBox.shrink(), // Handle any other data type or null case
            ],
          ),
        )
      ],
    ),
  );
}
