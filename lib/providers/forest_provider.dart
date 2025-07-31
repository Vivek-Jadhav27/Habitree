import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitree/data/models/species_model.dart';
import 'package:habitree/data/models/tree_model.dart';

class ForestProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Tree> _trees = [];
  List<Tree> get trees => _trees;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> loadForest() async {
    _isLoading = true;
    notifyListeners();

    final userId = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("garden")
        .orderBy("plantedDate")
        .get();

    _trees = snapshot.docs
        .map((doc) => Tree.fromMap(doc.id, doc.data()))
        .toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> growTreeWithDate(DateTime date) async {
    if (_trees.isEmpty) {
      final firstSpecies = await _getFirstSpecies();
      if (firstSpecies != null) {
        await _plantTree(firstSpecies, date);
        print("🌱 Planted first species id=${firstSpecies.id}");
      }
      return;
    }

    Tree lastTree = _trees.last;

    final speciesDoc = await _firestore
        .collection("species")
        .doc(lastTree.speciesId.toString())
        .get();
    if (!speciesDoc.exists) {
      print("❌ Species ${lastTree.speciesId} not found");
      return;
    }

    final speciesData = speciesDoc.data()!;
    final int maxStage = speciesData["stages"] ?? 1;

    // Compare only date part
    final lastGrownDay = DateTime(
      lastTree.lastGrownDate.year,
      lastTree.lastGrownDate.month,
      lastTree.lastGrownDate.day,
    );
    final dayKey = DateTime(date.year, date.month, date.day);

    if (lastGrownDay == dayKey) {
      print("⚠️ Already grown on $dayKey");
      return;
    }

    if (lastTree.stage < maxStage) {
      await _updateTree(lastTree.id, lastTree.stage + 1, date);
      print("🌿 Grew tree ${lastTree.id} to stage ${lastTree.stage}");
    } else {
      final nextSpecies = await _getNextSpecies(lastTree.speciesId);
      if (nextSpecies != null) {
        await _plantTree(nextSpecies, date);
        print("🌳 Planted next species id=${nextSpecies.id}");
      }
    }

    notifyListeners();
  }

  /// Plant new tree
  Future<void> _plantTree(Species species, DateTime plantedDate) async {
    final userId = _auth.currentUser!.uid;

    double x = 50 + (_trees.length * 120) % 100;
    double y = 50 + (_trees.length * 150);

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
    _trees.add(newTree);
    notifyListeners();
  }

  /// Update tree stage
  Future<void> _updateTree(String treeId, int newStage, DateTime date) async {
    final userId = _auth.currentUser!.uid;

    await _firestore
        .collection("users")
        .doc(userId)
        .collection("garden")
        .doc(treeId)
        .update({"stage": newStage, "lastGrownDate": date.toIso8601String()});

    final tree = _trees.firstWhere((t) => t.id == treeId);
    tree.stage = newStage;
    tree.lastGrownDate = date;
    notifyListeners();
  }

  /// Get first species
  Future<Species?> _getFirstSpecies() async {
    final snapshot = await _firestore
        .collection("species")
        .orderBy("id")
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return Species.fromMap(snapshot.docs.first.data());
  }

  /// Get next species (loop back if none)
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

    return await _getFirstSpecies();
  }

  void moveTree(Tree tree, Offset delta) async {
    tree.x += delta.dx;
    tree.y += delta.dy;

    notifyListeners(); // redraw immediately for smooth drag

    final userId = _auth.currentUser!.uid;
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("garden")
        .doc(tree.id)
        .update({"x": tree.x, "y": tree.y});
  }
}
