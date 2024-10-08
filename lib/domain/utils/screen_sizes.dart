import 'package:flutter/material.dart';

class ScreenSizes {
  BuildContext context;
  ScreenSizes(this.context);
  screenHeight() {
    return MediaQuery.of(context).size.height;
  }

  screenWidth() {
    return MediaQuery.of(context).size.width;
  }

  screenHeightFraction({required double percent}) {
    return MediaQuery.of(context).size.height * (percent / 100);
  }

  screenWidthFraction({required double percent}) {
    return MediaQuery.of(context).size.width * (percent / 100);
  }

  relativeWidth({required double parentWidth, required double percent}) {
    return parentWidth * (percent / 100);
  }

  relativeHeight({required double parentHeight, required double percent}) {
    return parentHeight * (percent / 100);
  }
}
 