class Tree {
  final String id; 
  final int speciesId;
  int stage;
  double x; 
  double y;
  final DateTime plantedDate;
  DateTime lastGrownDate;

  Tree({
    required this.id,
    required this.speciesId,
    required this.stage,
    required this.x,
    required this.y,
    required this.plantedDate,
    required this.lastGrownDate,
  });

  Map<String, dynamic> toMap() => {
        "speciesId": speciesId,
        "stage": stage,
        "x": x,
        "y": y,
        "plantedDate": plantedDate.toIso8601String(),
        "lastGrownDate": lastGrownDate.toIso8601String(),
      };

  factory Tree.fromMap(String id, Map<String, dynamic> map) => Tree(
        id: id,
        speciesId: map["speciesId"],
        stage: map["stage"],
        x: map["x"],
        y: map["y"],
        plantedDate: DateTime.parse(map["plantedDate"]),
        lastGrownDate: DateTime.parse(map["lastGrownDate"]),
      );
}