class PlantImage {
  String fileName;
  String url;

  PlantImage({
    this.url,
    this.fileName,
  });

  factory PlantImage.fromJson(Map<String, dynamic> json) => PlantImage(
        url: json != null ? json["url"] : '',
        fileName: json != null ? json["file_name"] : '',
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "file_name": fileName,
      };
}
