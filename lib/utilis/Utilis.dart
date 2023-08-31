import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

Align getMachineStatus(String lastMaintance , String maintainceEvery) {
  int numOfDays = DateTime.parse(lastMaintance)
      .add(Duration(days: int.parse(maintainceEvery)+1))
      .difference(DateTime.now())
      .inDays;

  switch (numOfDays) {
    case == 0:
      return const Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Row(
          children: [
            Text(
              "اليوم",
              style: TextStyle(
                color: Color(0xFFEE8B2F),
              ),
            ),
            Icon(
              PhosphorIcons.timer,
              color: Color(0xFFEE8B2F),
            )
          ],
        ),
      );
    case < 0:
      return Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Row(
          children: [
            Text(
              " متأخر${(numOfDays * -1).toInt()} يوم ",
              style: const TextStyle(
                color: Color(0xFFEE2F2F),
              ),
            ),
            const Icon(
              PhosphorIcons.timer,
              color: Color(0xFFEE2F2F),
            )
          ],
        ),
      );
    case > 5:
      return Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Row(
          children: [
            Text(
              " $numOfDays يوم عن الصيانة القادمة",
              style: const TextStyle(
                color: Color(0xFF475467),
              ),
            ),
            const Icon(
              PhosphorIcons.timer,
              color: Color(0xFF475467),
            )
          ],
        ),
      );
    default:
      return Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Row(
          children: [
            Text(
              " باقي $numOfDays أيام ",
              style: const TextStyle(
                color: Color(0xFFEE8B2F),
              ),
            ),
            const Icon(
              PhosphorIcons.timer,
              color: Color(0xFFEE8B2F),
            )
          ],
        ),
      );
  }
}

String URL_PROVIDER() {
  return "https://omunitedpower.com/api";
  // return "http://192.168.1.90/omUnited";
}
Future<void> LAUNCH_URL(link) async {
   await launchUrl(Uri.parse(link),mode: LaunchMode.externalApplication) ;
}