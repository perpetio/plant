import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant/core/settings.dart';

Future<void> getPlant({
  String image,
}) async {
  Dio dio = new Dio();

  var documentDirectory = await getApplicationDocumentsDirectory();
  // var firstPath = documentDirectory.path + "/images";
  var filePathAndName = documentDirectory.path + '/images/pic.jpg';

  File imageFile = new File(filePathAndName);

  // FormData formData = new FormData.fromMap(
  //   {
  //     "organs": "flower",
  //     "images": await MultipartFile.fromFile(
  //       imageFile.path,
  //       contentType: new MediaType("images", "jpg"),
  //     )
  //   },
  // );

  final response = await dio.post(
    "https://my-api.plantnet.org/v2/identify/all?api-key=" + plant_key,
    data: imageFile,
    options: Options(),
  );

  print(response);
}
