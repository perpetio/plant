class Plant {
  List<Data> data;

  Plant({this.data});

  Plant.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Data {
  int id;
  String commonName;
  String slug;
  String scientificName;
  int year;
  String bibliography;
  String author;
  String status;
  String rank;
  String familyCommonName;
  int genusId;
  String imageUrl;
  List<String> synonyms;
  String genus;
  String family;

  Data({
    this.id,
    this.commonName,
    this.slug,
    this.scientificName,
    this.year,
    this.bibliography,
    this.author,
    this.status,
    this.rank,
    this.familyCommonName,
    this.genusId,
    this.imageUrl,
    this.synonyms,
    this.genus,
    this.family,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commonName = json['common_name'];
    slug = json['slug'];
    scientificName = json['scientific_name'];
    year = json['year'];
    bibliography = json['bibliography'];
    author = json['author'];
    status = json['status'];
    rank = json['rank'];
    familyCommonName = json['family_common_name'];
    genusId = json['genus_id'];
    imageUrl = json['image_url'];
    synonyms = json['synonyms'].cast<String>();
    genus = json['genus'];
    family = json['family'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['common_name'] = this.commonName;
    data['slug'] = this.slug;
    data['scientific_name'] = this.scientificName;
    data['year'] = this.year;
    data['bibliography'] = this.bibliography;
    data['author'] = this.author;
    data['status'] = this.status;
    data['rank'] = this.rank;
    data['family_common_name'] = this.familyCommonName;
    data['genus_id'] = this.genusId;
    data['image_url'] = this.imageUrl;
    data['synonyms'] = this.synonyms;
    data['genus'] = this.genus;
    data['family'] = this.family;

    return data;
  }
}
