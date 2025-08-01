class Species {
  final int id;
  final String name;
  final int stages;
  final List<Map<String, dynamic>> stageRenderParams;

  Species({
    required this.id,
    required this.name,
    required this.stages,
    required this.stageRenderParams,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "stages": stages,
    "stageRenderParams": stageRenderParams,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stages': stages,
      'stageRenderParams': stageRenderParams,
    };
  }

  factory Species.fromMap(Map<String, dynamic> map) => Species(
    id: map["id"],
    name: map["name"],
    stages: map["stages"],
    stageRenderParams: List<Map<String, dynamic>>.from(
      map["stageRenderParams"]?.map((x) => Map<String, dynamic>.from(x)) ?? [],
    ),
  );

  // Helper to get render params for a specific stage
  Map<String, dynamic> getRenderParamsForStage(int stageNumber) {
    if (stageNumber > 0 &&
        stageNumber <= stages &&
        stageRenderParams.isNotEmpty) {
      return stageRenderParams[stageNumber - 1];
    }
    return {};
  }
}
