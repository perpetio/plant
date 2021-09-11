import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:plant/core/settings.dart';

Future<void> getPlant({String plant}) async {
  String url =
      "https://my-api.plantnet.org/v2/identify/all?images=string&organs=flower&include-related-images=false&api-key=" +
          plant_key;
  // 'https://trefle.io/api/v1/plants/search?token=$trefle_key&q=$plant';
  Map<String, String> header = {"Content-type": "application/json"};

  Response response = await http.get(url, headers: header);

  print(response.statusCode);
  print(response.body);

  if (response.statusCode != 200) throw Exception('Failed to load plant');
}
