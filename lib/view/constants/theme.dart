//colors
import 'package:flutter/material.dart';

const Color bgcolor = Color.fromRGBO(16, 16, 20, 1);
const Color blue = Color.fromRGBO(66, 133, 244, 1);
const Color textcolor = Color(0xffffffff);
const Color kUpperContainerColor = Color(0xff1E1E1E);
const Color kblackcolor = Color.fromRGBO(0, 0, 0, 1);
const Color uddeshhyacolor = Color.fromRGBO(230, 71, 70, 1);

//fontsizes
TextStyle? heading(BuildContext context) =>
    Theme.of(context).textTheme.displayLarge;
TextStyle? subHeading(BuildContext context) =>
    Theme.of(context).textTheme.displayMedium;
TextStyle? body2(BuildContext context) =>
    Theme.of(context).textTheme.bodyMedium;
TextStyle? body1(BuildContext context) => Theme.of(context).textTheme.bodyLarge;

//padding
const smallPadding = Padding(padding: EdgeInsets.only(top: 20));
const largePadding = Padding(padding: EdgeInsets.only(top: 40));
