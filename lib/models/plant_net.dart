class PlantDetect {
  double score;
  Species species;
  String image;

  PlantDetect({
    this.score,
    this.species,
    this.image,
  });

  factory PlantDetect.fromJson(Map<String, dynamic> json) => PlantDetect(
        score: json["score"],
        image: json["image"],
        species: Species.fromJson(json["species"]),
      );

  Map<String, dynamic> toJson() => {
        "score": score,
        "species": species.toJson(),
      };
}

class Species {
  String scientificNameWithoutAuthor;
  String scientificNameAuthorship;
  Family genus;
  Family family;
  List<String> commonNames;
  Species({
    this.scientificNameWithoutAuthor,
    this.scientificNameAuthorship,
    this.genus,
    this.family,
    this.commonNames,
  });

  factory Species.fromJson(Map<String, dynamic> json) => Species(
        scientificNameWithoutAuthor: json["scientificNameWithoutAuthor"],
        scientificNameAuthorship: json["scientificNameAuthorship"],
        genus: json["genus"] != null ? Family.fromJson(json["genus"]) : null,
        family: Family.fromJson(json["family"]),
        commonNames: json["commonNames"] != null
            ? List<String>.from(json["commonNames"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "scientificNameWithoutAuthor": scientificNameWithoutAuthor,
        "scientificNameAuthorship": scientificNameAuthorship,
        "genus": genus.toJson(),
        "family": family.toJson(),
        "commonNames": List<dynamic>.from(commonNames.map((x) => x)),
      };
}

class Family {
  Family({
    this.scientificNameWithoutAuthor,
    this.scientificNameAuthorship,
  });

  String scientificNameWithoutAuthor;
  String scientificNameAuthorship;

  factory Family.fromJson(Map<String, dynamic> json) => Family(
        scientificNameWithoutAuthor: json["scientificNameWithoutAuthor"],
        scientificNameAuthorship: json["scientificNameAuthorship"],
      );

  Map<String, dynamic> toJson() => {
        "scientificNameWithoutAuthor": scientificNameWithoutAuthor,
        "scientificNameAuthorship": scientificNameAuthorship,
      };
}
