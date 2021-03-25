import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:plant/core/settings.dart';
import 'package:plant/models/models.dart';

Future fetchPlants(File image) async {
  Dio dio = new Dio();

  FormData formData = new FormData.fromMap(
    {
      "organs": "flower",
      "images": await MultipartFile.fromFile(
        image.path,
        contentType: new MediaType("images", "jpg"),
      )
    },
  );

  Response response = await dio.post(
    "https://my-api.plantnet.org/v2/identify/all?api-key=" + api_key,
    data: formData,
    options: Options(),
  );

  print(response.data);

  if (response.statusCode != 200) throw Exception('Failed to load plant');

  List<Plant> results =
      jsonDecode(response.toString())['results'].map<Plant>((data) {
    return Plant.fromJson(data);
  }).toList();

  return results;
}
