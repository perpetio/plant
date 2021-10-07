class Plant {
  int id;
  String plantName;
  PlantDetails plantDetails;

  Plant({
    this.id,
    this.plantName,
    this.plantDetails,
  });
}

class PlantDetails {
  List<String> commonNames;
  String url;
  WikiDescription wikiDescription;
  Taxonomy taxonomy;
  List<WikiImages> wikiImages;
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
}

class WikiDescription {
  String value;
  String citation;

  WikiDescription({
    this.value,
    this.citation,
  });
}

class Taxonomy {
  String taxonomyClass;
  String family;
  String genus;

  Taxonomy({
    this.taxonomyClass,
    this.family,
    this.genus,
  });
}

class WikiImages {
  String value;

  WikiImages({this.value});
}
