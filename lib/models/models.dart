class Plant {
  double score;
  Species species;

  Plant({this.score, this.species});

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        score: json["score"].toDouble(),
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
        genus: Family.fromJson(json["genus"]),
        family: Family.fromJson(json["family"]),
        commonNames: List<String>.from(json["commonNames"].map((x) => x)),
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
