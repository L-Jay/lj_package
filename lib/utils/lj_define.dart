import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const FontWeight PingFangUltralight = FontWeight.w100;
const FontWeight PingFangThin = FontWeight.w200;
const FontWeight PingFangLight = FontWeight.w300;
const FontWeight PingFangRegular = FontWeight.w400;
const FontWeight PingFangMedium = FontWeight.w500;
const FontWeight PingFangSemibold = FontWeight.w600;
const FontWeight PingFangBold = FontWeight.bold;

typedef ObjectCallback<T> = void Function(T value);
typedef BoolCallback = void Function(bool value);

typedef ObjectCallbackResultN<T, N> = N Function(T value);
typedef CallbackResultN<N> = N Function();

Container quickContainer({
  double? width,
  double? height,
  AlignmentGeometry? alignment,
  Color? color,
  String? backgroundImage,
  EdgeInsets? margin,
  EdgeInsets? padding,
  Widget? child,
  double? circular,
  BoxShadow? boxShadow,
  List<Color>? gradientColors,
  List<AlignmentGeometry> gradientAlign = const [
    Alignment.centerLeft,
    Alignment.centerRight,
  ],
  Color? borderColor,
  double borderWidth = 0,
}) {
  return Container(
    width: width,
    height: height,
    margin: margin,
    padding: padding,
    alignment: alignment,
    child: child,
    decoration: BoxDecoration(
      color: color,
      image: backgroundImage == null
          ? null
          : DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                backgroundImage,
              ),
            ),
      borderRadius: circular == null ? null : BorderRadius.circular(circular),
      boxShadow: boxShadow != null
          ? [
              boxShadow,
            ]
          : null,
      gradient: gradientColors != null
          ? LinearGradient(
              begin: gradientAlign.first,
              end: gradientAlign.last,
              colors: gradientColors,
            )
          : null,
      border: borderColor != null
          ? Border.all(color: borderColor, width: borderWidth)
          : null,
    ),
  );
}

Text quickText(
  String text,
  double size,
  Color color, {
  FontWeight? fontWeight,
  TextOverflow? overflow,
  String? fontFamily,
}) {
  return Text(
    text,
    overflow: overflow,
    maxLines: overflow == null ? null : 1,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
    ),
  );
}

TextButton quickButton({
  required String text,
  required Color backgroundColor,
  required VoidCallback onPressed,
  double fontSize = 17,
  Color fontColor = Colors.white,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(text),
    style: buttonStyle(fontSize, fontColor),
  );
}

Widget gradientButton({
  required String text,
  required List<Color> gradientColors,
  required VoidCallback onPressed,
  double fontSize = 17,
  Color textColor = Colors.white,
  double? width,
  double? height,
  double? circular,
}) {
  return quickContainer(
    width: width,
    height: height,
    circular: circular,
    gradientColors: gradientColors,
    child: quickButton(
      text: text,
      backgroundColor: Colors.transparent,
      onPressed: onPressed,
    ),
  );
}

ButtonStyle buttonStyle(double fontSize, Color textColor,
    {Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1,
    FontWeight? fontWeight,
    shape}) {
  return ButtonStyle(
    textStyle: MaterialStateProperty.all(
        TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
    foregroundColor: MaterialStateProperty.all(textColor),
    backgroundColor: MaterialStateProperty.all(backgroundColor),
    side: borderColor != null
        ? MaterialStateProperty.all(
            BorderSide(color: borderColor, width: borderWidth))
        : null,
    shape: MaterialStateProperty.all(shape ?? StadiumBorder()),
  );
}

RichText? quickRichText(
  List<String> strings,
  List<TextStyle> textStyles,
) {
  if (strings.length != textStyles.length) return null;

  return RichText(
    text: TextSpan(
      children: List.generate(
        strings.length,
        (index) {
          return TextSpan(
            text: strings[index],
            style: textStyles[index],
          );
        },
      ),
    ),
  );
}

RichText? quickRichTextTap(
  double fontSize,
  List<String> strings,
  List<Color> textColors,
  List<VoidCallback> tapCallback,
) {
  if (strings.length != textColors.length) return null;

  return RichText(
    text: TextSpan(
      children: List.generate(
        strings.length,
        (index) {
          return TextSpan(
            text: strings[index],
            style: TextStyle(
              fontSize: fontSize,
              color: textColors[index],
            ),
            recognizer: TapGestureRecognizer()..onTap = tapCallback[index],
          );
        },
      ),
    ),
  );
}

DecorationImage quickBgImage(String image, {BoxFit boxFit = BoxFit.fill}) {
  return DecorationImage(
    fit: boxFit,
    image: AssetImage(image),
  );
}

Color randomColor() {
  return Color.fromARGB(255, Random().nextInt(256) + 0,
      Random().nextInt(256) + 0, Random().nextInt(256) + 0);
}

Future<int?> showActionSheet(
  BuildContext context,
  List<String> actionTitles, {
  String? title,
  String? message,
  String cancelTitle = '取消',
}) {
  return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: title == null ? null : Text(title),
          message: message == null ? null : Text(message),
          actions: actionTitles
              .map(
                (e) => CupertinoActionSheetAction(
                  child: Text(e),
                  onPressed: () {
                    Navigator.pop(context, actionTitles.indexOf(e));
                  },
                  isDefaultAction: true,
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            child: Text(cancelTitle),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      });
}
