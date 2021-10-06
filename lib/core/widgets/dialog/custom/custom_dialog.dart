import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../../../core/init/extensions/context/duration_extension.dart';
import '../../../../core/init/extensions/context/responsive_extension.dart';
import '../../../../core/init/extensions/context/theme_extension.dart';
import '../../../../core/init/extensions/string/locale_text_extensions.dart';
import 'platform_dialog.dart';

class CustomDialog extends PlatformSensitiveWidget {
  final Widget content;
  final Widget? title;
  final String rightButtonTextKey;
  final String leftButtonTextKey;
  final Function action;
  final Function()? leftButtonAction;
  // ignore: prefer_typing_uninitialized_variables
  static void defaultFunc() {}
  final Color? leftButtonTextColor;
  final Color? rightButtonTextColor;
  final Color? rightButtonColor;
  final Color? leftButtonColor;
  final bool willPop;

  const CustomDialog({
    required this.content,
    this.title,
    this.rightButtonTextKey = 'OK',
    this.action = defaultFunc,
    this.leftButtonTextKey = '',
    this.leftButtonAction,
    this.rightButtonTextColor,
    this.leftButtonTextColor,
    this.rightButtonColor,
    this.leftButtonColor,
    this.willPop = true,
    Key? key,
  }) : super(key: key);

  Future<void> show(BuildContext context) async {
    if (kIsWeb) {
      await showDialog(context: context, builder: (context) => this);
    } else {
      await showModal(
        configuration: FadeScaleTransitionConfiguration(
          transitionDuration: context.fast,
        ),
        context: context,
        builder: (context) => this,
      );
    }
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.width * 5)),
          elevation: 0,
          //backgroundColor: context.canvasColor,
          title: title ?? Container(),
          content: content,
          actions: _setDialogButton(context),
        );
      },
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CupertinoAlertDialog(
          title: title ?? Container(),
          content: content,
          actions: _setDialogButton(context),
        );
      },
    );
  }

  @override
  Widget buildMainWidget(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.width * 5)),
          elevation: 0,
          //backgroundColor: context.canvasColor,
          title: title ?? Container(),
          content: content,
          actions: _setDialogButton(context),
        );
      },
    );
  }

  List<Widget> _setDialogButton(BuildContext context) {
    final allButtons = <Widget>[];
    if (kIsWeb) {
      addButton(allButtons, context);
    } else if (Platform.isIOS) {
      addCupertino(allButtons, context);
    } else {
      addButton(allButtons, context);
    }
    return allButtons;
  }

  void addButton(allButtons, BuildContext context) {
    if (leftButtonTextKey != '') {
      allButtons.add(
        Padding(
          padding: getLeftButtonPadding(context),
          child: TextButton(
            style: defaultButtonStyle(
                context, leftButtonColor ?? context.canvasColor),
            onPressed: leftButtonAction ?? () => Navigator.of(context).pop(),
            child: Text(
              leftButtonTextKey.locale,
              style: context.headline4.copyWith(
                  color: leftButtonTextColor ?? context.primaryDarkColor),
            ),
          ),
        ),
      );
    }
    allButtons.add(
      Padding(
        padding: getButtonPadding(context),
        child: TextButton(
          style: defaultButtonStyle(
              context, rightButtonColor ?? context.canvasColor),
          onPressed: () async {
            if (willPop) Navigator.of(context).pop();
          },
          child: Text(
            rightButtonTextKey.locale,
            style: context.headline4.copyWith(
                color: rightButtonTextColor ?? context.primaryDarkColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void addCupertino(allButtons, BuildContext context) {
    if (leftButtonTextKey != '') {
      allButtons.add(
        Padding(
          padding: getLeftButtonPadding(context),
          child: CupertinoDialogAction(
            onPressed: leftButtonAction ?? () => Navigator.of(context).pop(),
            child: Text(
              leftButtonTextKey.locale,
              style: context.headline4.copyWith(color: leftButtonColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    allButtons.add(
      Padding(
        padding: getButtonPadding(context),
        child: CupertinoDialogAction(
          onPressed: () {
            if (willPop) Navigator.of(context).pop();
            action();
          },
          child: Text(
            rightButtonTextKey.locale,
            style: context.headline4.copyWith(color: rightButtonColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  EdgeInsets getButtonPadding(BuildContext context) {
    return EdgeInsets.only(
        right: context.width * 2, bottom: context.width * 1.4);
  }

  EdgeInsets getLeftButtonPadding(BuildContext context) {
    return EdgeInsets.only(
        bottom: context.width * 1.4, right: context.width * .8);
  }

  ButtonStyle defaultButtonStyle(BuildContext context, Color color) {
    return TextButton.styleFrom(
      backgroundColor: color,
      padding: EdgeInsets.symmetric(
          horizontal: context.width, vertical: context.height * .5),
      minimumSize: Size(context.width * 3.7, context.height * 4),
    );
  }
}
