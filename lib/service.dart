import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learning_wallpaper_app/model.dart';

class ApiService {
  var client = http.Client();
  Uri url = Uri.parse('https://api.pexels.com/v1/curated?per_page=80');

  Future<List<Empty?>?> getPhotos() async {
    print('started');
    try {
      var response = await client.get(url, headers: {
        'Authorization':
            '563492ad6f91700001000001e277d0113fc249e281a7369a12fde145'
      });
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        List photos = result['photos'];
        List<Empty> photoList = photos.map((e) => Empty.fromJson(e)).toList();
        return photoList;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<Empty?>?> loadMore({required int page}) async {
    var _url = Uri.parse('https://api.pexels.com/v1/curated?per_page=80&page=' +
        page.toString());
    try {
      var response = await client.get(_url, headers: {
        'Authorization':
            '563492ad6f91700001000001e277d0113fc249e281a7369a12fde145'
      });

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List photos = json['photos'];
        List<Empty> photoList = photos.map((e) => Empty.fromJson(e)).toList();
        return photoList;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
