import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitree/core/mock_data.dart';
import 'package:habitree/presentation/painters/forest_painter.dart';
import 'package:habitree/presentation/painters/tree_painter.dart';
import 'package:provider/provider.dart';
import 'package:habitree/core/routes.dart';
import 'package:habitree/providers/forest_provider.dart';

class ForestScreen extends StatelessWidget {
  const ForestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EF),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6EF),
        elevation: 0,
        title: Text(
          "Habitree",
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2F5233),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.park_rounded, color: Color(0xFF2F5233)),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.gardenLibrary);
            },
          ),
        ],
      ),
      body: Consumer<ForestProvider>(
        builder: (context, forestProvider, child) {
          if (forestProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (forestProvider.trees.isEmpty) {
            return Center(
              child: Text(
                "No trees yet.\nComplete habits to grow your first tree!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: const Color(0xFF2F5233),
                ),
              ),
            );
          }

          return Stack(
            children: [
              // Optional background painter
              Positioned.fill(
                child: CustomPaint(
                  painter: ForestPainter([]), // just background, no trees
                ),
              ),

              // Draw draggable trees individually
              ...forestProvider.trees.map((tree) {
                final species = MockData.speciesCollection[tree.speciesId];
                if (species == null) return const SizedBox();

                final stageIndex = (tree.stage - 1).clamp(
                  0,
                  species.stageRenderParams.length - 1,
                );
                final params = species.stageRenderParams[stageIndex];
                return Positioned(
                  left: tree.x,
                  top: tree.y,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      forestProvider.moveTree(tree, details.delta);
                    },
                    child: CustomPaint(
                      size: const Size(80, 120),
                      painter: TreePainter(
                        params,
                        seed: species.id + stageIndex, // 👈 same as your loop
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
