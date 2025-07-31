import 'package:flutter/material.dart';
import 'package:habitree/data/models/species_model.dart';
import 'package:habitree/data/models/tree_model.dart';
import 'package:habitree/presentation/painters/tree_painter.dart';
import 'package:habitree/core/mock_data.dart';

class ForestPainter extends CustomPainter {
  final List<Tree> trees;
  final Map<int, Species> speciesCollection = MockData.speciesCollection;

  ForestPainter(this.trees);

  @override
  void paint(Canvas canvas, Size size) {
    for (var tree in trees) {
      final species = speciesCollection[tree.speciesId];
      if (species == null) continue;

      final stageIndex = (tree.stage - 1).clamp(0, species.stageRenderParams.length - 1);
      final params = species.stageRenderParams[stageIndex];

      canvas.save();
      canvas.translate(tree.x, tree.y);

      const double treeWidth = 80;
      const double treeHeight = 120;

      TreePainter(
        params,
        seed: species.id +stageIndex, // stable seed
      ).paint(
        canvas,
        const Size(treeWidth, treeHeight),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ForestPainter oldDelegate) {
    return oldDelegate.trees != trees;
  }
}
