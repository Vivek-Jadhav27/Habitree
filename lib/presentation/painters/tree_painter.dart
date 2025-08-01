import 'package:flutter/material.dart';
import 'dart:math';

Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class TreePainter extends CustomPainter {
  final Map<String, dynamic> params;
  final int seed; 

  TreePainter(this.params, {this.seed = 42});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(seed);

    // Paint for trunk
    final Paint trunkPaint = Paint()
      ..color = _hexToColor(params['trunkColor'])
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * (params['baseTrunkWidthFactor'] ?? 0.05);

    final double trunkHeight =
        size.height * (params['baseTrunkHeightFactor'] ?? 0.3);

    // Draw a single trunk line (not a rectangle + line)
    final Offset start = Offset(size.width / 2, size.height);
    final Offset end = Offset(size.width / 2, size.height);
    canvas.drawLine(start, end, trunkPaint);

    // Start recursive branching
    _drawBranch(
      canvas,
      end.dx,
      end.dy,
      -pi / 2, // upwards
      trunkHeight * (params['branchLengthFactor'] ?? 0.6),
      trunkPaint.strokeWidth * (params['branchWidthFactor'] ?? 0.7),
      1,
      random,
    );
  }

  void _drawBranch(
    Canvas canvas,
    double x,
    double y,
    double angle,
    double length,
    double width,
    int depth,
    Random random,
  ) {
    if (depth > (params['maxDrawingDepth'] ?? 2) || length < 2) return;

    final dx = cos(angle) * length;
    final dy = sin(angle) * length;

    final branchPaint = Paint()
      ..color = _hexToColor(params['trunkColor'])
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    // Draw branch
    final Offset start = Offset(x, y);
    final Offset end = Offset(x + dx, y + dy);
    canvas.drawLine(start, end, branchPaint);

    // Branch splitting
    final spread = (params['branchAngleSpread'] ?? (pi / 4)).toDouble();

    _drawBranch(
      canvas,
      end.dx,
      end.dy,
      angle - spread,
      length * (params['branchLengthFactor'] ?? 0.7),
      width * (params['branchWidthFactor'] ?? 0.7),
      depth + 1,
      random,
    );

    _drawBranch(
      canvas,
      end.dx,
      end.dy,
      angle + spread,
      length * (params['branchLengthFactor'] ?? 0.7),
      width * (params['branchWidthFactor'] ?? 0.7),
      depth + 1,
      random,
    );

    // Draw leaves only at max depth
    if (depth == (params['maxDrawingDepth'] ?? 2)) {
      final leafPaint = Paint()..color = _hexToColor(params['leafColor']);
      final leaves =
          (params['minLeavesPerBranch'] ?? 1) +
          random.nextInt(
            ((params['maxLeavesPerBranch'] ?? 3) -
                    (params['minLeavesPerBranch'] ?? 1)) +
                1,
          );

      for (int i = 0; i < leaves; i++) {
        final offset = Offset(
          end.dx + random.nextDouble() * 12 - 6,
          end.dy + random.nextDouble() * 12 - 6,
        );
        canvas.drawCircle(
          offset,
          (params['leafSize'] ?? 4.0).toDouble(),
          leafPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }
}