import 'dart:convert';

import 'package:eylsion/models/video_res.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final String apiKey =
      "keJlAiZ3mmAS9m5wqPomN2MZ7MJk5Fxcu5rECJHAzG5ZSCNkq37vzY8M";
  static String mainUrl = "https://api.pexels.com";
  var getFeed = '$mainUrl/videos/search';

  Future<FeedResponse> getFeeds() async {
    var params = {
      "query": "Ocean",
      "page": "2",
      "size": "medium",
      "orientation": "portrait"
    };

    Uri uri = Uri.parse(getFeed).replace(queryParameters: params);

    try {
      final response = await http.get(
        uri,
        headers: {
          "Authorization": apiKey,
        },
      );

      if (response.statusCode == 200) {
        return FeedResponse.fromJson(json.decode(response.body));
      } else {
        return FeedResponse.withError(
            "Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (error) {
      return FeedResponse.withError("$error");
    }
  }
}
