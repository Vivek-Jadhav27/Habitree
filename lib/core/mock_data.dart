import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitree/data/models/species_model.dart';

class MockData {
  static final Map<int, Species> speciesCollection = {
    1: Species(
      id: 1,
      name: "Oak Tree",
      stages: 2,
      stageRenderParams: [
        {
          'trunkColor': '#A0522D',
          'leafColor': '#556B2F',
          'baseTrunkHeightFactor': 0.2,
          'baseTrunkWidthFactor': 0.04,
          'maxDrawingDepth': 1,
          'branchLengthFactor': 0.6,
          'branchWidthFactor': 0.6,
          'branchAngleSpread': pi / 3.0,
          'minLeavesPerBranch': 1,
          'maxLeavesPerBranch': 2,
          'leafSize': 4.0,
        },
        {
          'trunkColor': '#8B4513',
          'leafColor': '#6B8E23',
          'baseTrunkHeightFactor': 0.35,
          'baseTrunkWidthFactor': 0.06,
          'maxDrawingDepth': 3,
          'branchLengthFactor': 0.7,
          'branchWidthFactor': 0.7,
          'branchAngleSpread': pi / 2.8,
          'minLeavesPerBranch': 2,
          'maxLeavesPerBranch': 4,
          'leafSize': 6.0,
        },
      ],
    ),

    2: Species(
      id: 2,
      name: "Pine Tree",
      stages: 3,
      stageRenderParams: [
        {
          'trunkColor': '#8B5A2B',
          'leafColor': '#228B22',
          'baseTrunkHeightFactor': 0.25,
          'baseTrunkWidthFactor': 0.03,
          'maxDrawingDepth': 2,
          'branchLengthFactor': 0.5,
          'branchWidthFactor': 0.5,
          'branchAngleSpread': 0.8,
          'minLeavesPerBranch': 3,
          'maxLeavesPerBranch': 5,
          'leafSize': 3.0,
        },
        {
          'trunkColor': '#654321',
          'leafColor': '#006400',
          'baseTrunkHeightFactor': 0.4,
          'baseTrunkWidthFactor': 0.05,
          'maxDrawingDepth': 3,
          'branchLengthFactor': 0.6,
          'branchWidthFactor': 0.6,
          'branchAngleSpread': 0.9,
          'minLeavesPerBranch': 4,
          'maxLeavesPerBranch': 6,
          'leafSize': 5.0,
        },
        {
          'trunkColor': '#3E2723',
          'leafColor': '#013220',
          'baseTrunkHeightFactor': 0.5,
          'baseTrunkWidthFactor': 0.07,
          'maxDrawingDepth': 4,
          'branchLengthFactor': 0.7,
          'branchWidthFactor': 0.7,
          'branchAngleSpread': 1.0,
          'minLeavesPerBranch': 5,
          'maxLeavesPerBranch': 8,
          'leafSize': 6.0,
        },
      ],
    ),

    3: Species(
      id: 3,
      name: "Sakura Tree",
      stages: 4,
      stageRenderParams: [
        // Stage 1 → Small sapling
        {
          'trunkColor': '#8B4513',
          'leafColor': '#FFC0CB',
          'baseTrunkHeightFactor': 0.15,
          'baseTrunkWidthFactor': 0.03,
          'maxDrawingDepth': 1,
          'branchLengthFactor': 0.5,
          'branchWidthFactor': 0.6,
          'branchAngleSpread': 0.9,
          'minLeavesPerBranch': 1,
          'maxLeavesPerBranch': 2,
          'leafSize': 3.0,
        },
        // Stage 2 → Growing with few branches
        {
          'trunkColor': '#5C4033',
          'leafColor': '#FFB6C1',
          'baseTrunkHeightFactor': 0.25,
          'baseTrunkWidthFactor': 0.04,
          'maxDrawingDepth': 2,
          'branchLengthFactor': 0.6,
          'branchWidthFactor': 0.7,
          'branchAngleSpread': 1.0,
          'minLeavesPerBranch': 2,
          'maxLeavesPerBranch': 4,
          'leafSize': 4.0,
        },
        // Stage 3 → Blossoming
        {
          'trunkColor': '#4B2E2E',
          'leafColor': '#FF69B4',
          'baseTrunkHeightFactor': 0.35,
          'baseTrunkWidthFactor': 0.05,
          'maxDrawingDepth': 3,
          'branchLengthFactor': 0.7,
          'branchWidthFactor': 0.7,
          'branchAngleSpread': 1.2,
          'minLeavesPerBranch': 4,
          'maxLeavesPerBranch': 6,
          'leafSize': 5.0,
        },
        // Stage 4 → Full bloom
        {
          'trunkColor': '#3E2723',
          'leafColor': '#FF1493',
          'baseTrunkHeightFactor': 0.45,
          'baseTrunkWidthFactor': 0.06,
          'maxDrawingDepth': 4,
          'branchLengthFactor': 0.75,
          'branchWidthFactor': 0.7,
          'branchAngleSpread': 1.3,
          'minLeavesPerBranch': 6,
          'maxLeavesPerBranch': 10,
          'leafSize': 6.0,
        },
      ],
    ),
    4: Species(
      id: 4,
      name: "Baobab Tree",
      stages: 3,
      stageRenderParams: [
        // Stage 1 → Thick sapling
        {
          'trunkColor': '#A0522D',
          'leafColor': '#9ACD32',
          'baseTrunkHeightFactor': 0.2,
          'baseTrunkWidthFactor': 0.08, // Thicker trunk from early stage
          'maxDrawingDepth': 1,
          'branchLengthFactor': 0.4,
          'branchWidthFactor': 0.7,
          'branchAngleSpread': 0.6,
          'minLeavesPerBranch': 1,
          'maxLeavesPerBranch': 2,
          'leafSize': 6.0, // bigger leaves
        },
        // Stage 2 → Expanding trunk with branches
        {
          'trunkColor': '#8B4513',
          'leafColor': '#6B8E23',
          'baseTrunkHeightFactor': 0.35,
          'baseTrunkWidthFactor': 0.12, // much wider
          'maxDrawingDepth': 2,
          'branchLengthFactor': 0.5,
          'branchWidthFactor': 0.8,
          'branchAngleSpread': 0.9,
          'minLeavesPerBranch': 2,
          'maxLeavesPerBranch': 4,
          'leafSize': 8.0,
        },
        // Stage 3 → Iconic bottle shape with crown leaves
        {
          'trunkColor': '#5C4033',
          'leafColor': '#228B22',
          'baseTrunkHeightFactor': 0.45,
          'baseTrunkWidthFactor': 0.18, // very thick trunk
          'maxDrawingDepth': 3,
          'branchLengthFactor': 0.6,
          'branchWidthFactor': 0.9,
          'branchAngleSpread': 1.2,
          'minLeavesPerBranch': 4,
          'maxLeavesPerBranch': 7,
          'leafSize': 10.0, // large leaves forming a crown
        },
      ],
    ),
    
  };
  static Future<void> uploadSpeciesData(
    Map<int, Species> speciesCollection,
  ) async {
    final firestore = FirebaseFirestore.instance;
    final speciesRef = firestore.collection('species');

    for (final entry in speciesCollection.entries) {
      final species = entry.value;
      await speciesRef.doc(species.id.toString()).set(species.toJson());
      print("Uploaded ${species.name}");
    }
  }
}
