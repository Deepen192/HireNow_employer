import 'package:flutter_application_2/consts/consts.dart';

Widget productImages({required label,onPress}){
  return "$label".text.bold.color(fontGrey).size(16.0).makeCentered().box.color(lightGrey).size(100, 100).roundedSM.make();
}