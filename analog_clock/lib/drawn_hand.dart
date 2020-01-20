// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const DrawnHand({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
    @required this.insideColor,
  })  : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        assert(insideColor != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;
  final Color insideColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            handSize: size,
            lineWidth: thickness,
            angleRadians: angleRadians,
            color: color,
            insideColor: insideColor,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class _HandPainter extends CustomPainter {
  _HandPainter({
    @required this.handSize,
    @required this.lineWidth,
    @required this.angleRadians,
    @required this.color,
    @required this.insideColor,
  })  : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(insideColor != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  Color color;
  Color insideColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = -1 * (angleRadians + math.pi / 2.0); // in other side! ok! :-)
    final length = size.shortestSide * 0.5 * handSize;
    final position = center + Offset(math.cos(angle), math.sin(angle)) * (length - 5);
    final position1 = center + Offset(math.cos(angle + .05), math.sin(angle + .05)) * (length - length / 12);
    final position2 = center + Offset(math.cos(angle - .05), math.sin(angle - .05)) * (length - length / 12);
    final centerCircle = center + Offset(math.cos(angle), math.sin(angle)) * length / 2.5;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.square;
    final insidePaint = new Paint()
      ..color = insideColor
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    //canvas.drawLine(center, position, linePaint);
    canvas.drawCircle(centerCircle, length / 2, linePaint);
    canvas.drawCircle(centerCircle, (length - 20) / 2, insidePaint);
    canvas.drawPath(
      new Path()
      ..moveTo(position.dx, position.dy)
      ..lineTo(position1.dx, position1.dy)
      ..lineTo(position2.dx, position2.dy)
      ..close(),
      new Paint()
      ..color = color
      ..style = PaintingStyle.fill
    );
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
