import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SetWallpaperScreen extends StatelessWidget {
  const SetWallpaperScreen({Key? key, required this.imageUrl})
      : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    Future<void> setWallpaper() async {
      String result;
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
// Platform messages may fail, so we use a try/catch PlatformException.
      try {
        result = await AsyncWallpaper.setWallpaperFromFile(
          filePath: file.path,
          wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
          goToHome: true,
        )
            ? 'Wallpaper set'
            : 'Failed to get wallpaper.';
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Wallpaper has been successfully set'),
          backgroundColor: Colors.green,
        ));
      } on PlatformException {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Wallpaper could not be set'),
          backgroundColor: Colors.red,
        ));
        result = 'Failed to get wallpaper.';
      }
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () async {
                await setWallpaper();
              },
              child: const Center(
                child: Text(
                  'Set Wallpaper',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
