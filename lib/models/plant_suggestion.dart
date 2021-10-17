import 'package:plant/models/plant_model.dart';

class PlantSuggestion {
  int id;
  String plantName;
  PlantDetails plantDetails;

  PlantSuggestion({
    this.id,
    this.plantName,
    this.plantDetails,
  });

  factory PlantSuggestion.fromJson(Map<String, dynamic> json) =>
      PlantSuggestion(
        id: json != null ? json['id'] : 0,
        plantName: json != null ? json['plant_name'] : '',
        plantDetails: PlantDetails.fromJson(json["plant_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plant_name": plantName,
        "plant_details": plantDetails.toJson(),
      };
}
