import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitree/core/mock_data.dart';

class GardenLibraryScreen extends StatelessWidget {
  const GardenLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6EF),
        elevation: 0,
        title: Text(
          "Garden Library",
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2F5233),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: MockData.speciesCollection.entries.map((entry) {
          final species = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  species.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2F5233),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(species.stages, (index) {
                    final params = species.stageRenderParams[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 160,
                          child: CustomPaint(
                            painter: TreePainter(
                              params,
                              seed: species.id + index,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Stage ${index + 1}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TreePainter extends CustomPainter {
  final Map<String, dynamic> params;
  final int seed; // 👈 to make randomness stable per species/stage/plant

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
