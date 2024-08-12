
import 'package:flutter_application_2/consts/consts.dart';

Widget normalText({text, color = Colors.white, double? size}) {
  return "$text".text.color(color).size(size ?? 14.0).make();
}

Widget boldText({text, color = Colors.white, double? size}) {
  return "$text".text.semiBold.color(color).size(size ?? 14.0).make();
}
