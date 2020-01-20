// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Color(0xff857555),
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Color(0xff997555),
  _Element.shadow: Color(0xFF81B3FE),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        //Duration(minutes: 1) -
            //Duration(seconds: _dateTime.second) -
            Duration(seconds: 1) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final seconds = _dateTime.second;
    final fontSize = (MediaQuery.of(context).size.width / 3.5) * (seconds % 2 == 0 ? 1 : 0.99);
    final jumpDoublePoint =  60.0 - (seconds % 2 != 0 ? 5.0 : -5.0);
    final rearrangeDigital = _dateTime.minute % 2 == 0 ? 0.0 : -60.0;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'PressStart2P',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 20,
          color: colors[_Element.shadow],
          offset: Offset(0, 0),
        ),
      ],
    );

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Stack(
            children: <Widget>[

              Positioned(
                top: 30 - rearrangeDigital,
                left: 40,
                right: 0,
                child: Text(hour,
                style: TextStyle(
                  //color: Color(0xff857555),
                  fontWeight: FontWeight.w900,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: fontSize),
                textAlign: TextAlign.left),
              ),

              Positioned(
                top: jumpDoublePoint,
                left: 0,
                right: 0,
                child: Text(':',
                style: TextStyle(
                  //color: Color(0xff857555),
                  fontWeight: FontWeight.w600,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: fontSize),
                textAlign: TextAlign.center),
              ),

              Positioned(
                top: 90 + rearrangeDigital,
                left: 0,
                right: 40,
                child: Text(minute,
                style: TextStyle(
                  //color: Color(0xff857555),
                  fontWeight: FontWeight.w900,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: fontSize),
                textAlign: TextAlign.right),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
