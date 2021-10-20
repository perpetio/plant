import 'package:flutter/material.dart';
import 'package:plant/models/plant_image.dart';

class PlantsModels {
  final List<PlantImage> plantsImages;
  final List<PlantModel> plantModels;

  PlantsModels({
    @required this.plantsImages,
    @required this.plantModels,
  });

  factory PlantsModels.fromJson(Map<String, dynamic> json) {
    final images = (json["images"] as List) ?? [];
    final plants = (json["suggestions"] as List) ?? [];
    return PlantsModels(
      plantsImages: images.map((e) => PlantImage.fromJson(e)).toList(),
      plantModels: plants.map((e) => PlantModel.fromJson(e)).toList(),
    );
  }

  String getPlantName() {
    if (plantModels.isNotEmpty) {
      return plantModels.first.plantName;
    }
    return "";
  }

  Map<String, dynamic> toJson() => {
        "images": plantsImages.map((e) => e.toJson()).toList(),
        "suggestions": plantModels.map((e) => e.toJson()).toList(),
      };
}

class PlantModel {
  int id;
  String plantName;
  PlantDetails plantDetails;

  PlantModel({
    this.id,
    this.plantName,
    this.plantDetails,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) => PlantModel(
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

class PlantDetails {
  List<String> commonNames;
  String url;
  WikiDescription wikiDescription;
  Taxonomy taxonomy;
  List<WikiImage> wikiImages;
  List<String> synonyms;
  List<String> propagationMethods;

  PlantDetails({
    this.commonNames,
    this.url,
    this.wikiDescription,
    this.taxonomy,
    this.wikiImages,
    this.synonyms,
    this.propagationMethods,
  });

  factory PlantDetails.fromJson(Map<String, dynamic> json) {
    // List<WikiImage> tempWikiImages = <WikiImage>[];
    // if (json['wiki_images'] != null) {
    //   json['wiki_images'].forEach((v) {
    //     tempWikiImages.add(WikiImage.fromJson(v));
    //   });
    //   // for (final Map<String, dynamic> data in json['wiki_images'] as List) {
    //   //   tempWikiImages.add(WikiImage.fromJson(data));
    //   // }
    // }
    return PlantDetails(
      commonNames: List<String>.from(json["common_names"] ?? [].map((e) => e)),
      url: json != null ? json["url"] : '',
      wikiDescription: WikiDescription.fromJson(json["wiki_description"]),
      taxonomy: Taxonomy.fromJson(json["taxonomy"]),
      // wikiImages: tempWikiImages != null ? tempWikiImages : [],
      synonyms: List<String>.from((json["synonyms"] ?? []).map((e) => e)),
      propagationMethods:
          List<String>.from((json["propagation_methods"] ?? []).map((e) => e)),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["common_names"] = commonNames;
    data["url"] = url;
    data["wiki_description"] = wikiDescription.toJson();
    data["taxonomy"] = taxonomy.toJson();

    if (wikiImages != null) {
      data['wiki_images'] = wikiImages.map((e) => e.toJson()).toList();
    }

    data["synonyms"] = synonyms;
    data["propagationMethods"] = propagationMethods;

    return data;
  }
}

class WikiDescription {
  String value;
  String citation;

  WikiDescription({
    this.value,
    this.citation,
  });

  factory WikiDescription.fromJson(Map<String, dynamic> json) =>
      WikiDescription(
        value: json != null ? json["value"] : "",
        citation: json != null ? json["citation"] : "",
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "citation": citation,
      };
}

class Taxonomy {
  String tClass;
  String family;
  String genus;

  Taxonomy({
    this.tClass,
    this.family,
    this.genus,
  });

  factory Taxonomy.fromJson(Map<String, dynamic> json) => Taxonomy(
        tClass: json != null ? json["class"] : "",
        family: json != null ? json["family"] : "",
        genus: json != null ? json["genus"] : "",
      );

  Map<String, dynamic> toJson() => {
        "class": tClass,
        "family": family,
        "genus": genus,
      };
}

class WikiImage {
  String value;

  WikiImage({this.value});

  factory WikiImage.fromJson(Map<String, dynamic> json) => WikiImage(
        value: json != null ? json['value'] : '',
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}
