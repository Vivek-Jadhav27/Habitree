import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitree/data/models/species_model.dart';
import 'package:habitree/data/models/tree_model.dart';

class ForestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Tree> trees = [];

  /// Load user's garden
  Future<void> loadForest() async {
    final userId = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("garden")
        .orderBy("plantedDate")
        .get();

    trees = snapshot.docs
        .map((doc) => Tree.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Grow tree at a given simulated date
  Future<void> growTreeWithDate(DateTime date) async {
    if (trees.isEmpty) {
      // 🌱 Plant first tree (first species from species collection)
      final firstSpecies = await _getFirstSpecies();
      if (firstSpecies != null) {
        await plantTree(firstSpecies, date);
        print("Planted first species id=${firstSpecies.id}");
      }
      return;
    }

    Tree lastTree = trees.last;

    // Get species info
    final speciesDoc = await _firestore
        .collection("species")
        .doc(lastTree.speciesId.toString())
        .get();

    if (!speciesDoc.exists) {
      print("❌ Species ${lastTree.speciesId} not found in collection");
      return;
    }

    final speciesData = speciesDoc.data()!;
    final int maxStage = speciesData["stages"] ?? 1;

    // Compare dates (ignore time)
    final lastGrownDay = DateTime(
      lastTree.lastGrownDate.year,
      lastTree.lastGrownDate.month,
      lastTree.lastGrownDate.day,
    );
    final dayKey = DateTime(date.year, date.month, date.day);

    if (lastGrownDay == dayKey) {
      print("⚠️ Already grown for $dayKey");
      return;
    }

    if (lastTree.stage < maxStage) {
      // 🌿 Grow same tree
      await updateTree(lastTree.id, lastTree.stage + 1, date);
      print("🌿 Tree ${lastTree.id} grew to stage ${lastTree.stage}");
    } else {
      // 🌳 Plant next species
      final nextSpecies = await _getNextSpecies(lastTree.speciesId);
      if (nextSpecies != null) {
        await plantTree(nextSpecies, date);
        print("🌳 Planted new species id=${nextSpecies.id}");
      }
    }
  }

  /// Plant a new tree of given species
  Future<void> plantTree(Species species, DateTime plantedDate) async {
    final userId = _auth.currentUser!.uid;

    double x = 50 + (trees.length * 120);
    double y = 50 + (trees.length * 150);

    final newDoc = _firestore
        .collection("users")
        .doc(userId)
        .collection("garden")
        .doc();

    Tree newTree = Tree(
      id: newDoc.id,
      speciesId: species.id,
      stage: 1,
      x: x,
      y: y,
      plantedDate: plantedDate,
      lastGrownDate: plantedDate,
    );

    await newDoc.set(newTree.toMap());
    trees.add(newTree);
  }

  /// Update existing tree stage
  Future<void> updateTree(String treeId, int newStage, DateTime date) async {
    final userId = _auth.currentUser!.uid;

    final treeDoc = _firestore
        .collection("users")
        .doc(userId)
        .collection("garden")
        .doc(treeId);

    await treeDoc.update({
      "stage": newStage,
      "lastGrownDate": date.toIso8601String(),
    });

    final tree = trees.firstWhere((tree) => tree.id == treeId);
    tree.stage = newStage;
    tree.lastGrownDate = date;
  }

  /// Get first species from collection
  Future<Species?> _getFirstSpecies() async {
    final snapshot = await _firestore
        .collection("species")
        .orderBy("id")
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Species.fromMap(snapshot.docs.first.data());
  }

  /// Get next species by ID (or loop back to first)
  Future<Species?> _getNextSpecies(int currentId) async {
    final snapshot = await _firestore
        .collection("species")
        .where("id", isGreaterThan: currentId)
        .orderBy("id")
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Species.fromMap(snapshot.docs.first.data());
    }

    return await _getFirstSpecies(); // loop back
  }
}
