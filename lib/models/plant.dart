class Plant {
  int id;
  String plantName;
  PlantDetails plantDetails;

  Plant({
    this.id,
    this.plantName,
    this.plantDetails,
  });

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        id: json["id"],
        plantName: json["plant_name"],
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
    List<WikiImage> tempWikiImages = <WikiImage>[];
    if (json['wiki_images'] != null) {
      for (final Map<String, dynamic> data in json['wiki_images'] as List) {
        tempWikiImages.add(WikiImage.fromJson(data));
      }
    }
    return PlantDetails(
      commonNames: List<String>.from(json["common_names"].map((e) => e)),
      url: json["url"],
      wikiDescription: WikiDescription.fromJson(json["wiki_description"]),
      taxonomy: Taxonomy.fromJson(json["taxonomy"]),
      wikiImages: tempWikiImages,
      synonyms: List<String>.from((json["synonyms"] ?? []).map((e) => e)),
      propagationMethods:
          List<String>.from((json["propagation_methods"] ?? []).map((e) => e)),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["common_names"] = commonNames;
    data["url"] = url;
    data["wiki_description"] = wikiDescription.toJson();
    data["taxonomy"] = taxonomy.toJson();
    // "common_names": commonNames,
    // "url": url,
    // "wiki_description": wikiDescription.toJson(),
    // "taxonomy": taxonomy.toJson(),

    if (data != null) {
      data['wiki_images'] = wikiImages.map((e) => e.toJson()).toList();
    }

    return data;
    // "wiki_images": wikiImages
    //     .map((e) => WikiImages.fromJson(e as Map<String, dynamic>)),
    // "synonyms": List<dynamic>.from(synonyms.map((e) => e)),
    // "propagation_methods":
    //     List<dynamic>.from(propagationMethods.map((e) => e)),
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
        value: json["value"],
        citation: json["citation"],
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
        tClass: json["class"],
        family: json["family"],
        genus: json["genus"],
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
        value: json['value'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}
